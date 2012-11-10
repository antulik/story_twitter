class TwitterSynchronizer

  attr_accessor :user

  def set_headers
    Calendar.headers['authorization'] = 'Bearer ' + user.story_token
    Event.headers['authorization']    = 'Bearer ' + user.story_token
  end

  def initialize user
    self.user = user
  end

  def create_twitter_home_timeline
    set_headers

    calendars = Calendar.all
    calendar  = calendars.detect { |c| c.external_type == 'home_timeline' }

    if calendar.nil?
      Calendar.create({
          summary:           "Twitter home timeline",
          synchronizer_name: self.class.name,
          external_type:     'home_timeline',
          external_id:       '',
          color:             "#33ccff"
      })
    else
      calendar
    end
  end

  def sync_events calendar, options = {}
    #end_date   = options[:end] || DateTime.now
    #start_date = options[:start] || end_date - 6.month

    sync_home_timeline(calendar)

  end

  #protected

  def sync_home_timeline calendar
    tweets = home_timeline.map do |tweet|
      {
          :external_id => tweet.id.to_s,
          :summary     => tweet.text,
          :description => "",
          :start       => tweet.created_at,
          :raw_data    => tweet.to_hash
      }
    end

    Event.post(:import, {:calendar_id => calendar.id}, tweets.to_json)
  end

  def home_timeline
    max_retries = 3

    retries = 0
    begin
      client.home_timeline(:count => 200)
    rescue Twitter::Error::BadRequest
      retries += 1
      if retries <= max_retries
        retry
      end
      []
    end
  end

  def client
    @client ||= Twitter::Client.new(
        :oauth_token        => user.twitter_token,
        :oauth_token_secret => user.twitter_secret
    )
  end

end
