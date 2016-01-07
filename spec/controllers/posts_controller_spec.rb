require "rails_helper"

describe PostsController do
  context "when slack token is valid" do
    it "responds with HTTP 200" do
      get :latest_post_url, token: Rails.application.secrets.slack_token
      expect(response).to be_ok
    end

    it "renders json" do
      get :latest_post_url, token: Rails.application.secrets.slack_token
      expect(response.content_type).to eq("application/json")
    end

    it "renders correct content" do
      get :latest_post_url, token: Rails.application.secrets.slack_token
      response_hash = JSON.parse(response.body)

      expect(response_hash).to have_key("response_type")
      expect(response_hash).to have_key("unfurl_media")
      expect(response_hash).to have_key("attachments")
    end
  end

  context "when slack token is invalid" do
    it "responds with HTTP 200" do
      get :latest_post_url, token: "4321"
      expect(response).to be_ok
    end

    it "renders nothing" do
      get :latest_post_url, token: "1234"
      expect(response.content_type).to eq("text/plain")
      expect(response.body).to be_empty
    end
  end

  context "when facebook authorisation doesn't succeed" do
    it "responds with HTTP 200" do
      allow_any_instance_of(PostsController).to receive(:access_token).and_return("")
      get :latest_post_url, token: Rails.application.secrets.slack_token
      expect(response).to be_ok
    end

    it "renders error message" do
      allow_any_instance_of(PostsController).to receive(:access_token).and_return("")
      get :latest_post_url, token: Rails.application.secrets.slack_token
      response_hash = JSON.parse(response.body)
      expect(response_hash).to have_value("Cannot connect to Facebook :(")
    end
  end
end
