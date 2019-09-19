require "rails_helper"

RSpec.describe "Health Check", type: :request do
  it "returns an ok HTTP status code without requiring authentication" do
    get "/health_check", headers: {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)).to eql("rails" => "OK")
  end
end
