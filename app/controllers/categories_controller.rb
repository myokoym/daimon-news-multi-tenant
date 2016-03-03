class CategoriesController < ApplicationController
  helper_method :current_category

  before_action :prepare_search, only: %i(show)

  def show
    @category = current_site.categories.find_by!(slug: params[:id])
    @posts = current_site.posts.where(category: @category).published.order_by_recently.page(params[:page])
  end

  private

  def current_category
    @category
  end
end
