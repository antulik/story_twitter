require "bundler/setup"
require "bundler/capistrano"

set :application, "story_twitter"
set :server_name, 'story_twitter.antonkatunin.com'
set :repository, 'git@github.com:antulik/story_twitter.git'

set :dotenv_config_enabled, true

require 'antulik/server1/config'

require "whenever/capistrano"
