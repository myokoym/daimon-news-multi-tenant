after 'development:credit_roles', 'development:participants', 'development:posts' do
  site1 = Site.find_by!(name: 'site1')
  credit_role = site1.credit_roles.first!

  site1.posts.published.order_by_recently.limit(10).each_with_index do |post, i|
    post.credits.create!(
      participant: site1.participants[i % 2],
      role: credit_role
    )
  end
end
