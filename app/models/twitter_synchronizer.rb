class TwitterSynchronizer

  attr_accessor :user

  def initialize user
    self.user = user
  end

  def create_twitter_home_timeline
    calendar = user.calendars.where(:external_type => 'home_timeline').first
    if calendar.nil?
      user.calendars.create!({
          summary:           "Twitter home timeline",
          synchronizer_name: self.class.name,
          external_type:     'home_timeline',
          external_id:       '',
          color:             "#33ccff"
      })
    end
  end

  def sync_events calendar, options = {}
    #end_date   = options[:end] || DateTime.now
    #start_date = options[:start] || end_date - 6.month

    sync_home_timeline(calendar)
  end

  protected

  def sync_home_timeline calendar
    home_timeline.each do |tweet|
      event = calendar.events.where(:external_id => tweet.id.to_s).first

      attributes = {
          :external_id => tweet.id.to_s,
          :summary     => tweet.text,
          :description => "",
          :start       => tweet.created_at,
          :raw_data    => tweet.to_hash
      }
      if event.nil?
        calendar.events.create(attributes)
      else
        event.update_attributes(attributes)
      end

    end
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
        :oauth_token        => provider.token,
        :oauth_token_secret => provider.secret
    )
  end

  def provider
    user.providers.twitter
  end

end
