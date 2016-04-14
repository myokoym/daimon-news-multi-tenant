class CustomCssController < ApplicationController
  before_action :redirect_to_correct_css_url

  def show
    render text: generate_custom_css(current_site), content_type: "text/css"
  end

  private

  def current_site
    @current_site ||= Site.find_by!(fqdn: params[:fqdn])
  end

  def redirect_to_correct_css_url
    redirect_to self.class.helpers.asset_path(current_site.css_location) unless current_site.custom_css_available?
  end

  def generate_custom_css(site)
    with_tmp_dir(Rails.root.join("tmp/custom_css")) do |dir|
      assets = Rails.application.assets

      site_path = Pathname(dir).join("custom")
      original_css_path = assets.resolve("themes/default/application.css")

      FileUtils.cp_r(Pathname(original_css_path).join("../"), site_path)

      overwrite_variables(site_path) do |variables|
        variables.gsub(/^(\$base-hue: *)\d+(.+)$/, "\\1 #{site.base_hue}\\2")
      end

      assets[site_path.join("application.scss")]
    end
  end

  def with_tmp_dir(tmp_dir)
    FileUtils.mkdir_p(tmp_dir)

    result = nil

    # Keep file path to use Sprockets' cache. However it might be crush on multi-threaded mode...
    if working_on_multi_threaded?
      Dir.mktmpdir(nil, tmp_dir) do |dir|
        result = yield(dir)
      end
    else
      result = yield(tmp_dir)
    end

    result
  end

  def working_on_multi_threaded?
    request.env[Rack::Lock::FLAG]
  end

  def overwrite_variables(site_path)
    variables_path = site_path.join("_variables.scss")
    original_mtime = variables_path.mtime

    variables_path.write(yield(variables_path.read))

    FileUtils.touch(variables_path, mtime: original_mtime) # To Sprockets' cache
  end
end
