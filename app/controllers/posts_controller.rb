class PostsController < ApplicationController
  def latest_post_url
    if params['token'] == Rails.application.secrets.slack_token
      render plain: "Sucharek nr 1"
    else
      render nothing: true
    end
  end
end
