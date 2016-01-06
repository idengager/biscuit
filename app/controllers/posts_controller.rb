class PostsController < ApplicationController
  def latest_post_url
    if params['token'] == Rails.application.secrets.slack_token
      url = "https://fbcdn-sphotos-h-a.akamaihd.net/hphotos-ak-xpf1/v/t1.0-9/s720x720/12400685_1025642710821896_3357628243610338772_n.jpg?oh=d3689d87c2452478f3c4e8830c99f4a9&oe=57488E66&__gda__=1464322765_143a29a1a789a4c1122739df31bddb55"
      response_hash = {
        response_type: "in_channel",
        unfurl_media: true,
        attachments: [
          {
            fallback: "Psie Sucharki FTW – #{url}",
            title: "Psie Sucharki FTW",
            image_url: url
          }
        ]
      }
      render json: response_hash
    else
      render nothing: true
    end
  end
end
