require 'test_helper'

class FixedPageTest < ActionDispatch::IntegrationTest
  setup do
    site = create(:site)
    editor = create(:user, sites: [site])
    login_as_editor(site: site, editor: editor)

    within '.navbar-nav' do
      click_on '固定ページ'
    end
    click_on 'New Fixed page'

    fill_in 'Title', with: 'About daimon-news'
    fill_in 'Body',  with: <<~EOS
      ## What is daimon-news

      daimon-news is the application to open news sites fast and easy.
    EOS
    fill_in 'Slug', with: 'about'

    click_on '登録する'
  end

  test 'body is converted to html' do
    visit '/about'

    within '.post__body' do
      assert page.has_selector?('h2', text: 'What is daimon-news')
    end
  end
end
