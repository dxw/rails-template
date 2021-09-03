Rails.application.configure do
  config.lograge.formatter = Lograge::Formatters::Json.new
  config.lograge.ignore_actions = ["ApplicationController#health_check"]
  config.lograge.custom_options = lambda do |event|
    {time: Time.now.utc}
  end
  config.lograge.custom_payload do |controller|
    {
      host: controller.request.host,
      user_id: controller.try(:current_user).try(:id) || "undefined"
    }
  end
end
