require 'test_helper'

class BreadcrumbsTest < ActionDispatch::IntegrationTest
  setup do
    @site = create(:site)
    @category = create(:category, site: @site)
    create_list(:post, 21, category: @category, site: @site)

    switch_domain(@site.fqdn)

    visit '/'
  end

  test 'Top page has breadcrumbs except first page' do
    assert_not page.has_css?('.breadcrumbs')

    click_on '次へ'

    assert_equal 'Press 2ページ目', find('.breadcrumbs').text
    assert_equal 2, all('.breadcrumbs__fragment').count
    assert_equal "http://#{@site.fqdn}/", find('.breadcrumbs__link')[:href]
  end

  test 'Category page has page number breadcrumbs except first page' do
    within '.sidebar' do
      click_on @category.name
    end

    assert_equal "Press #{@category.name}", find('.breadcrumbs').text

    click_on '次へ'

    assert_equal "Press #{@category.name} 2ページ目", find('.breadcrumbs').text
    assert_equal 3, all('.breadcrumbs__fragment').count
    assert_equal "http://#{@site.fqdn}/", find('.breadcrumbs__fragment:nth-child(1) .breadcrumbs__link')[:href]
    assert_equal "http://#{@site.fqdn}/category/#{@category.slug}", find('.breadcrumbs__fragment:nth-child(2) .breadcrumbs__link')[:href]
  end
end
