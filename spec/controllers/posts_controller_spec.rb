require "rails_helper"

describe PostsController do
  def facebook_response
    {
     "data": [
        {
           "full_picture": "https://fbcdn-sphotos-a-a.akamaihd.net/hphotos-ak-xla1/v/t1.0-9/s720x720/12512611_1026668354052665_5369779569253905988_n.jpg?oh=d1dbb82c02b0666cdd790bf58486f1d2&oe=5712BB14&__gda__=1464276150_09ab56661dd0da3a80226c7b23bbba40",
           "id": "808519212534248_1026668354052665"
        }
      ]
    }
  end

  context "when slack token is valid" do
    before do
      stub_request(
        :get,
        "https://graph.facebook.com/psiesucharki/posts?" \
        "access_token=1047755528610055%7C091fd9388223a226d5951a309690f10f&" \
        "fields=full_picture&limit=1"
      ).to_return(status: 200, body: facebook_response.to_json)
    end

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
    before do
      stub_request(
        :get,
        "https://graph.facebook.com/psiesucharki/posts?" \
        "access_token=&" \
        "fields=full_picture&limit=1"
      ).to_return(status: 401)
    end

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
