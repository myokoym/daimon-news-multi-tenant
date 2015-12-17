Site.create!(
  name: 'site1',
  fqdn: ENV['HEROKU_APP_NAME'].present? ? "#{ENV['HEROKU_APP_NAME']}.herokuapp.com" : 'localhost',
  js_url:  'https://rawgit.com/bm-sms/daimon-news-multi-tenant/a7a19c9d984df9ca4d2d481e537cfd81db8c3a5d/site.js',
  css_url: 'https://rawgit.com/bm-sms/daimon-news-multi-tenant/a7a19c9d984df9ca4d2d481e537cfd81db8c3a5d/site.css'
)

Site.create!(
  name:    'site2',
  js_url:  'https://rawgit.com/myokoym/public-site1/master/site.js',
  css_url: 'https://rawgit.com/myokoym/public-site1/master/site.css'
)