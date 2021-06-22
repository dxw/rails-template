Pry.config.color = true

if defined?(Rails)
  production_env = ENV.fetch("PRODUCTION_ENV", "production")

  if Rails.env.production? && Rails.application.sandbox == false
    production_warning = "Warning: You are using the #{production_env} console in non-sandboxed mode"

    puts
    puts Pry::Helpers::Text.red("*" * production_warning.size)
    puts Pry::Helpers::Text.red(production_warning)
    puts Pry::Helpers::Text.red("*" * production_warning.size)
    puts
  end

  environment_prompt = if Rails.env.production?
    "(" + Pry::Helpers::Text.red(production_env) + ")"
  else
    "(" + Pry::Helpers::Text.green(Rails.env) + ")"
  end

  sandbox_prompt = Rails.application.sandbox ? "(sandbox)" : "(writable)"

  Pry.config.prompt_name = [
    environment_prompt,
    " ",
    sandbox_prompt,
    " "
  ].join
end
