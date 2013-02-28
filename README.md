Colonel
=======

Gem for cron jobs editing by web GUI. It is not finished.
Please, try to check the state of this project later.
But if you want use it right now anyway you need to read lines below.

## Usage

Add colonel to your Gemfile:

    gem 'colonel', :git => 'git@github.com:santaux/colonel.git'

Install it:

    bundle

Run application into your terminal and use:

    bundle exec colonel

Stop application when you want:

    bundle exec colonel -K

Or use it directly through your irb/rails console:

    require 'colonel'
    builder = Colonel::Builder.new
    jobs = builder.parse

