redis_url = 'localhost:6789/0'

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url, namespace: "rails_template_#{Rails.env}" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url, namespace: "rails_template_#{Rails.env}" }
end
