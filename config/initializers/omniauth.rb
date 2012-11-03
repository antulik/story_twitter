require 'omniauth'

module OmniAuth
  module Strategies
    class Story < OmniAuth::Strategies::OAuth2
      # change the class name and the :name option to match your application name
      option :name, :story

      option :client_options, {
          :site => "http://localhost:3000",
          :authorize_url => "/oauth/authorize"
      }

      uid { raw_info["id"] }

      info do
        {
            :email => raw_info["email"]
        # and anything else you want to return to your API consumers
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v1/me.json').parsed
      end
    end
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :developer unless Rails.env.production?

  TWITTER_KEY = "A5U7NNrj1JnJoL9sBw"
  TWITTER_SECRET = "2MYIHAvKnliYH3RaP16WOo6V4o6I5G6kdqKfbtV7b4g"
  provider :twitter, TWITTER_KEY, TWITTER_SECRET

  DOORKEEPER_APP_ID = 'd1ee72f2e5a4bc43814845a5a72b2619b50fe21ebe5aa84581d67007d66eb8cb'
  DOORKEEPER_APP_SECRET = 'b3a13271f07d6582c183d9e1dcf79a40353d96d60ec77274ce791e41055e5a5c'
  DOORKEEPER_APP_URL = 'http://localhost:3000'
  provider :story, DOORKEEPER_APP_ID, DOORKEEPER_APP_SECRET, :client_options =>  {:site => DOORKEEPER_APP_URL}
end