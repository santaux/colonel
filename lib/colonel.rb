require "colonel/version"

# TODO: Rewrite views with helpers
# TODO: Add bootstrap
# TODO: Add ActiveModel methods to classes
# TODO: Add ability to import/export crontab files
# TODO: Move it to gem as rails engine
# TODO: Move it to gem as sinatra app
# TODO: Make import/output of templates
module Colonel
  require 'colonel/builder'
  require 'colonel/crontab'
  require 'colonel/job'
  require 'colonel/parser'
end
