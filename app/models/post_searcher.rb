class PostSearcher
  def initialize
    @posts = Groonga['Posts']
  end

  def related_post_ids(post, limit: 5)
    related_posts = @posts.select do |record|
      conditions = (record.index('Words.Posts_title').similar_search(post.title))
      conditions |= (record.index('Words.Posts_content').similar_search(post.body))
      if post.author
        conditions |= (record.author._key == post.author.id)
      end
      if post.category
        conditions |= (record.category._key == post.category.id)
      end
      conditions &
        (record.published_at <= Time.now) &
        (record.site._key == post.site_id) &
        (record._key != post.id)
    end
    related_posts.sort([["_score", :desc]], limit: limit).map do |related_post|
      related_post._key
    end
  end

  def search(query, page: nil, size: nil)
    posts = @posts.select do |record|
      conditions = []
      full_text_search = record.match(query.keywords) do |target|
        (target.index('Terms.Posts_title') * 10) |
          target.index('Terms.Posts_content')
      end
      conditions << full_text_search
      conditions
    end

    page = (page || 1).to_i
    size = (size || 100).to_i
    retried = false
    begin
      sorted_posts = posts.paginate([["_score", :desc]],
                                    page: (page || 1).to_i,
                                    size: (size || 100).to_i)
    rescue Groonga::TooSmallPage, Groonga::TooLargePage
      raise if retried
      page = 1
      retried = true
      retry
    end
    sorted_posts.extend(Kaminalize)
    sorted_posts
  end

  module Kaminalize
    def entry_name
      'post'
    end

    def offset_value
      (start_offset || 1) - 1
    end

    def limit_value
      page_size
    end

    def total_pages
      n_pages
    end

    def total_count
      n_records
    end
  end
end