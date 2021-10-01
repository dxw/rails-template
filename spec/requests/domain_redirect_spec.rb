RSpec.describe "Canonical domain redirect" do
  before(:all) do
    ENV["CANONICAL_HOSTNAME"] = "http://example.com"
    Rails.application.reload_routes!
  end

  after(:all) do
    ENV["CANONICAL_HOSTNAME"] = ""
    Rails.application.reload_routes!
  end

  it "redirects to the canonical domain" do
    expect(get("http://example.org/claim/new")).to redirect_to("http://example.com/claim/new")
    expect(response.status).to eq(301)
  end

  it "keeps the original path" do
    expect(get("http://example.org/cookies")).to redirect_to("http://example.com/cookies")
    expect(response.status).to eq(301)
  end

  it "keeps query strings in place" do
    expect(get("http://example.org/cookies?foo=bar")).to redirect_to("http://example.com/cookies?foo=bar")
    expect(response.status).to eq(301)
  end
end
