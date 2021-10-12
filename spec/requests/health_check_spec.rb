RSpec.describe "Health Check" do
  it "returns an ok HTTP status code without requiring authentication" do
    get "/health_check", headers: {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)).to include("rails" => "OK")
  end

  it "includes the git_sha if it is present" do
    ClimateControl.modify CURRENT_GIT_SHA: "123-abc-456-def" do
      get "/health_check", headers: {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("git_sha" => "123-abc-456-def")
    end
  end

  it "includes the built_at datetime if it is present" do
    ClimateControl.modify TIME_OF_BUILD: Time.zone.today.strftime("%Y-%m-%dT%H:%M:%S") do
      get "/health_check", headers: {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("built_at" => Time.zone.today.strftime("%Y-%m-%dT%H:%M:%S"))
    end
  end

  it "returns UNKNOWN if the git_sha and / or built_at are unset" do
    ClimateControl.modify CURRENT_GIT_SHA: nil, TIME_OF_BUILD: nil do
      get "/health_check", headers: {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("built_at" => "UNKNOWN")
      expect(JSON.parse(response.body)).to include("git_sha" => "UNKNOWN")
    end
  end
end
