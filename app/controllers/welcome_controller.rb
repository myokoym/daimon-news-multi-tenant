class WelcomeController < ApplicationController
  before_action :prepare_search, only: %i(index)

  def index
    @posts  = current_site.posts.published.order_by_recently.page(params[:page])
  end
end
