class PostsController < ApplicationController
  def latest_post_url
    if params["token"] == Rails.application.secrets.slack_token
      render json: response_hash
    else
      render nothing: true
    end
  end

  private

  def access_token
    # this is a (documented) way of authenticating your app without actually
    # fetching an access token from Facebook
    "#{Rails.application.secrets.facebook_key}|#{Rails.application.secrets.facebook_secret}"
  end

  def image_url
    client = Koala::Facebook::API.new(access_token)
    begin
      client.get_connection(
        "psiesucharki",
        "posts",
        { limit: 1, fields: ["full_picture"] }
        ).first["full_picture"]
    rescue Koala::Facebook::ClientError
      ""
    end
  end

  def response_hash
    return { text: "Cannot connect to Facebook :(" } if image_url.empty?
    {
      response_type: "in_channel",
      unfurl_media: true,
      attachments: [
        {
          fallback: "Psie Sucharki FTW – #{image_url}",
          title: "Psie Sucharki FTW",
          image_url: image_url
        }
      ]
    }
  end
end
