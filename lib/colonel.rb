require "colonel/version"
require 'colonel/array'

# TODO: Rewrite views with helpers
# TODO: Add ActiveModel methods to classes
# TODO: Add ability to import/export crontab files
# TODO: Move it to gem as rails engine
# TODO: Make import/output of templates
module Colonel
  require 'colonel/builder'
  require 'colonel/crontab'
  require 'colonel/job'
  require 'colonel/parser'
end

class Array
  include Colonel::Array
end
