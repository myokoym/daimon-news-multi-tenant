# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)

# 1.lvh.me:3000 で /sites/1/posts を表示する
# TODO: これだけだとCSSが当たらない
use Rack::Subdomain, 'lvh.me', to: '/sites/:subdomain/posts'

run Rails.application
