# Biscuit

This is a tiny Rails app that will get you the latest image from
[Psie Sucharki Facebook page](https://www.facebook.com/psiesucharki/) right into
your Slack channel. It uses Slack's slash commands and Facebook's Graph API under
the hood.

## How it works

You type in a command and get a picture in return. Here's a
[GIF](http://imgur.com/4Y5ti6g) of that happening.

## Set it up

You'll need Facebook, Slack, and a place to host this app.

### Host the app

Put it on the interwebz.
[Heroku](https://devcenter.heroku.com/articles/getting-started-with-ruby#introduction)
is good for that.

### Add a slash command to your team's Slack

Go to [Slack's app builder](https://slack.com/apps/build) and choose `Custom
Integration` and then `Slash Commands`. You can use whatever command name you
like. Click `Add`. Set the request method to `GET` and the address to
`your-apps-public-url/latest_post_url`.

You'll need the token to configure your app, so store it somewhere safe for
a while.

### Register a new app with Facebook

Visit [Facebook developers app dashboard](https://developers.facebook.com/apps/)
and click `Add A New App`. Choose a name and the category for your app. Once
it's created, go to `Settings > Basic`.

Save `App ID` and `App Secret`. (You will have to type in your password to
reveal the `App Secret`.)

### Configure your app

Put the Slack token and Facebook credentials as environment variables into
your production environment. If you're using Heroku, consult their
[docs on config vars](https://devcenter.heroku.com/articles/config-vars).

Have fun!

## Troubleshooting

You need to set up the credentials from Slack and Facebook correctly for the
app to work.

It will send back a message to the user via the Slack Bot when Slack token is
invalid or when it has been denied access to the Facebook API so that they know
what's going on.

## Author

Kasia Jarmołkowicz

## License

MIT
