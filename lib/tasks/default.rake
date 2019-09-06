task default: %i[standard spec] if Rails.env.test? || Rails.env.development?
