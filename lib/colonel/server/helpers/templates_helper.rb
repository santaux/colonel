module TemplatesHelper
  def template_cmds
    [
      {
        value: "/bin/bash -l -c 'cd /srv/kliprr/current && bundle exec backup perform --trigger sample_backup'",
        name: "BackUP"
      },
      {
        value: "/bin/bash -l -c 'cd /srv/kliprr/current && RAILS_ENV=production bundle exec rake schedule:daily_emails'",
        name: "Daily Emails"
      },
      {
        value: "/bin/bash -l -c 'cd /srv/kliprr/current && RAILS_ENV=production bundle exec rake schedule:immediate_emails'",
        name: "Immediate Emails"
      },
      {
        value: "/bin/bash -l -c 'cd /srv/kliprr/current && RAILS_ENV=production bundle exec rake schedule:sync_counters'",
        name: "Synchronize Object Counter"
      },
      {
        value: "/bin/bash -l -c 'cd /srv/kliprr/current && RAILS_ENV=production bundle exec rake schedule:cloudinary_cleanup'",
        name: "Cloudinary CleanUp"
      },
      {
        value: "/bin/bash -l -c 'cd /srv/kliprr/current && RAILS_ENV=production bundle exec rake current_time_fake:start'",
        name: "Getting new klips from Sex.com"
      },
      {
        value: "/bin/bash -l -c 'cd /srv/kliprr/current && RAILS_ENV=production bundle exec rake fake_reklips:start'",
        name: "Fake reklips script"
      },
      {
        value: "/bin/bash -l -c 'cd /srv/kliprr/current && RAILS_ENV=production bundle exec rake fake_follows:start'",
        name: "Fake follows script"
      },
      {
        value: "/bin/bash -l -c 'cd /srv/kliprr/current && RAILS_ENV=production bundle exec rake kliprr_twitts:start'",
        name: "Kliprr account twitts for twitter and tumblr"
      }
    ]
  end

  def command_with_templates(command)
    template = template_cmds.select { |cmd| cmd[:value] == command }.first
    template ? template[:name] : command
  end

  def selected?(period, i)
    @job && @job.schedule.send(period).include?(i.to_s) && "selected"
  end
end