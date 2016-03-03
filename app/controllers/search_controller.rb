class SearchController < ApplicationController
  before_action :prepare_search, only: %i(search)

  def search
    searcher = PostSearcher.new
    @result_set = searcher.search(@query, page: params[:page])
  end
end
