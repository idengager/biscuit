require "rails_helper"

describe PostsController do
  it "responds with HTTP 200" do
    get :latest_post_url, token: ""
    expect(response).to be_ok
  end

  it "renders plain text" do
    get :latest_post_url, token: ""
    expect(response.content_type).to eq("text/plain")
    expect(response.body).not_to eq("Sucharek nr 1")
  end

  context "when slack token is valid" do
    it "renders correct content" do
      get :latest_post_url, token: Rails.application.secrets.slack_token
      expect(response.body).to eq("Sucharek nr 1")
    end
  end

  context "when slack token is invalid" do
    it "renders nothing" do
      get :latest_post_url, token: "1234"
      expect(response.body).not_to eq("Sucharek nr 1")
    end
  end
end
