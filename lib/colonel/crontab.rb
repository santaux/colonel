require 'tempfile'

module Colonel
  class Crontab
    def initialize(user)
      @user = user
    end

    def read
      @tab = `crontab -l`
    end

    def lines
      @_lines ||= read.split(/\n/)
    end

    def reject_useless
      lines.reject { |line| reject_if_wrong(line) }
    end

    def reject_if_wrong(line)
      !line.match /^(\d+|\*)/
    end

    def update(jobs)
      update_tab(jobs)
      write
    end

    def update_tab(jobs)
      tab_lines = jobs.map do |j|
        [
          TimeCreator.new(
            minutes:  j.schedule.minutes,
            hours:    j.schedule.hours,
            days:     j.schedule.days,
            months:   j.schedule.months,
            weekdays: j.schedule.weekdays,
          ).generate,
          j.command.get
        ].join("\t\t\t")
      end
      tab_lines
      @tab = "# --- Updated with Colonel ---\n" + tab_lines.join("\n") + "\n# --- \n"
    end

    def write_to_temp
      @tempfile = Tempfile.new("#{@user}_crontab_temp")
      @tempfile.write(@tab)
      @tempfile.close
    end

    def write
      write_to_temp
      `crontab #{@tempfile.path}`
      @tempfile.delete
    end

    class TimeCreator
      def initialize(opts={})
        @minutes = opts[:minutes]
        @hours = opts[:hours]
        @days = opts[:days]
        @months = opts[:months]
        @weekdays = opts[:weekdays]
      end

      def generate
        [@minutes, @hours, @days, @months, @weekdays].map { |t| t.is_a?(Array) ? t.join(",") : t }.join(" ")#.join("\t")
      end
    end
  end
end
