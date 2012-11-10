TWITTER_KEY    = "A5U7NNrj1JnJoL9sBw"
TWITTER_SECRET = "2MYIHAvKnliYH3RaP16WOo6V4o6I5G6kdqKfbtV7b4g"

DOORKEEPER_APP_ID     = '12cf47c0c166b39af3501fc233625288f61e427e2a8b99088a653d506533f411'
DOORKEEPER_APP_SECRET = '6c8c335a843e41e2a6a82dbeff53ae8c025d3b43fbc6f12ee44fe27ee454be51'
DOORKEEPER_APP_URL    = 'http://localhost:3000'

SyncTwitter::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true
end
