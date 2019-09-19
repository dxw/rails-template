# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def health_check
    render json: {rails: "OK"}, status: :ok
  end
end
