# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def health_check
    render json: {
      rails: "OK",
      git_sha: ENV.fetch("CURRENT_GIT_SHA", "UNKNOWN"),
      built_at: ENV.fetch("TIME_OF_BUILD", "UNKNOWN")
    }, status: :ok
  end
end
