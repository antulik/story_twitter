require 'omniauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, TWITTER_KEY, TWITTER_SECRET
  provider :story, DOORKEEPER_APP_ID, DOORKEEPER_APP_SECRET, :client_options => {:site => DOORKEEPER_APP_URL}
end