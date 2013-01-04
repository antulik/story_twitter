class TwitterSynchronizer

  attr_accessor :user

  def initialize user
    self.user = user
  end

  def create_twitter_home_timeline
    calendars = story_client.calendars
    calendar  = calendars.detect { |c| c.external_type == 'home_timeline' }

    if calendar.nil?
      story_client.calendar_create({
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

  def story_client
    @story_client ||= StoryGem::Client.new(:oauth_token => user.story_token)
  end

  #protected

  def sync_home_timeline calendar
    tweets = home_timeline.map do |tweet|
      {
          :external_id => tweet.id.to_s,
          :summary     => tweet.text,
          :description => "",
          :size        => tweet.retweet_count,
          :start       => tweet.created_at,
          :raw_data    => tweet.to_hash
      }
    end

    story_client.events_import(calendar.id, tweets)
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
