module StoryLine

  class Client < OAuth2::Client
    # Return a new OAuth2::Client object specific to the app.
    def initialize
      super(
          DOORKEEPER_APP_ID,
          DOORKEEPER_APP_SECRET,
          :site => DOORKEEPER_APP_URL,
          :token_method => :post,
          :parse_json => true
      )
    end
  end

  class Token < OAuth2::AccessToken
    # Return a new OAuth2::AccessToken specific to the app
    # and the user with the given token.
    def initialize(token)
      super(
          StoryLine::Client.new,
          token
      )
    end

    def calendars
      get('/api/v1/calendars.json').parsed['calendars']
    end
  end
end