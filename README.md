Colonel
=======

Gem for cron jobs editing by web GUI. Web GUI is based on Sinatra, Vegas
and Twitter Bootstrap.

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

## Screenshots
![Jobs list](https://github.com/santaux/colonel/raw/master/screenshots/jobs_list.png "jobs list")
![Job editing](https://github.com/santaux/colonel/raw/master/screenshots/job_editing.png "job editing")
![Job deleting](https://github.com/santaux/colonel/raw/master/screenshots/job_deleting.png "job deleting")
![New job validating](https://github.com/santaux/colonel/raw/master/screenshots/new_job_validating.png "new job validating")
