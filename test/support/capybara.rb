module DomainHelper
  extend ActiveSupport::Concern

  DEFAULT_HOST = "http://www.example.com".freeze

  included do
    setup before: :prepend
    def setup_capybara_default_host
      Capybara.default_host = DEFAULT_HOST
    end
  end

  def switch_domain(domain)
    Capybara.default_host = 'http://' + domain
  end
end

ActionDispatch::IntegrationTest.include(DomainHelper)

Capybara.add_selector(:row) do
  xpath {|text| "//tr[./td[text() = '#{text}']]" }
end
