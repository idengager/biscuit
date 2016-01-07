class PostsController < ApplicationController
  def latest_post_url
    if params['token'] == Rails.application.secrets.slack_token
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

  def latest_post_from_facebook
    client = Koala::Facebook::API.new(access_token)
    client.get_connection(
      'psiesucharki',
      'posts',
      { limit: 1, fields: ['full_picture'] }
    )
  end

  def response_hash
    image_url = latest_post_from_facebook.first['full_picture']
    response_hash = {
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
