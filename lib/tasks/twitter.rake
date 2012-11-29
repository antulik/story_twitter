task :fetch_home_timelines => :environment do

  User.all.each do |user|
    user.sync_twitter_home_timeline
  end

end