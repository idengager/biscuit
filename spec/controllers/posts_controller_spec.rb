require "rails_helper"

describe PostsController do
  it "responds with HTTP 200" do
    get :latest_post_url
    expect(response).to be_ok
  end

  it "renders plain text" do
    get :latest_post_url
    expect(response.content_type).to eq("text/plain")
  end

  it "renders correct content" do
    get :latest_post_url
    expect(response.body).to eq("Sucharek nr 1")
  end
end
