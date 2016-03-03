class FixedPagesController < ApplicationController
  before_action :prepare_search, only: %i(show)

  def show
    @fixed_page = current_site.fixed_pages.find_by!(slug: params[:slug])
  end
end
