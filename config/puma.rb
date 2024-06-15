# Puma設定ファイル

workers Integer(ENV['WEB_CONCURRENCY'] || 2)

threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup

# 既存のport設定行を置き換える
port        ENV.fetch("PORT") { 3000 }, "0.0.0.0"

environment ENV.fetch("RACK_ENV") { 'development' }

on_worker_boot do
  # Rails 4.1+ のワーカー固有の設定
  # 参照: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
