require 'test_helper'

class CanonicalTest < ActionDispatch::IntegrationTest
  setup do
    @post = create(:post,
      title:        'Hi',
      body:         <<~EOS,
        # Hi
        this is daimon
      EOS
    )

    switch_domain(@post.site.fqdn)
  end

  test 'Canonical must be absolute path' do
    visit '/'

    within '.main-pane' do
      click_on 'Hi'
    end

    assert_equal "http://#{@post.site.fqdn}/#{@post.id}?all=true", find('link[rel=canonical]', visible: false)[:href]
  end

  sub_test_case 'category page' do
    setup do
      @category = create(:category, site: @post.site)
    end

    test 'Cannonical must be shown' do
      visit "/category/#{@category.slug}"
      assert_equal "http://#{@post.site.fqdn}/category/#{@category.slug}?all=true",
                   find('link[rel=canonical]', visible: false)[:href]
    end

    test 'Cannonical must be unified for pagenation' do
      visit "/category/#{@category.slug}?page=2"
      assert_equal "http://#{@post.site.fqdn}/category/#{@category.slug}?all=true",
                   find('link[rel=canonical]', visible: false)[:href]
    end

    test 'Cannonical must be unified with special parameters' do
      visit "/category/#{@category.slug}?aaa=bbb&c_c=d.d"
      assert_equal "http://#{@post.site.fqdn}/category/#{@category.slug}?all=true",
                   find('link[rel=canonical]', visible: false)[:href]
    end

    test 'Cannonical is not shown if all=true' do
      visit "/category/#{@category.slug}?all=true"
      assert_raise Test::Unit::Capybara::ElementNotFound do
        find('link[rel=canonical]', visible: false)[:href]
      end
    end
  end
end
