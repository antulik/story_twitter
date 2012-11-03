class User < ActiveRecord::Base
  authenticates_with_sorcery!
  # attr_accessible :title, :body

  def create_twitter_home_timeline
    TwitterSynchronizer.new(self).create_twitter_home_timeline
  end

  def sync_twitter_home_timeline
    calendar = calendars.where(:external_type => 'home_timeline').first

    if calendar.nil?
      calendar = create_twitter_home_timeline
    end

    calendar.sync_events
  end


end
