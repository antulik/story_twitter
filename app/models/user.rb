class User < ActiveRecord::Base
  authenticates_with_sorcery!
  # attr_accessible :title, :body

  def create_twitter_home_timeline
    sync.create_twitter_home_timeline
  end

  def sync_twitter_home_timeline
    calendar = sync.create_twitter_home_timeline
    sync.sync_events(calendar)
  end

  def access_token
    StoryLine::Token.new(story_token)
  end

  def sync
    @sync ||= TwitterSynchronizer.new(self)
  end

end
