require 'omniauth'

module OmniAuth
  module Strategies
    class Story < OmniAuth::Strategies::OAuth2
      # change the class name and the :name option to match your application name
      option :name, :story

      option :client_options, {
          #:site          => "http://localhost:3000", # overwrite in initializer
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
  provider :twitter, TWITTER_KEY, TWITTER_SECRET
  provider :story, DOORKEEPER_APP_ID, DOORKEEPER_APP_SECRET, :client_options => {:site => DOORKEEPER_APP_URL}
end