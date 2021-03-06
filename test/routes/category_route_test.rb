class CategoryRouteTest < ActionDispatch::IntegrationTest
  def setup
    @site = create(:site)
    @category = create(:category, site: @site)
    https!
    host! @site.fqdn
  end

  def test_first_page
    get "/category/#{@category.slug}"
    assert_response(:success)
  end

  def test_redirect_to_2nd_page
    get "/category/#{@category.slug}/page/2"
    assert_response(:moved_permanently)
    assert_redirected_to("/category/#{@category.slug}?page=2")
  end
end
