module Colonel
  class Parser

    SCHEDULE_SIZE = 5
    PERIOD  = /@hourly|@daily|@weekly|@monthly|@yearly/

    def initialize(text, opts={})
      @all_flag = opts[:all_flag].nil? ? true : opts[:all_flag]
      filtered_text = replace_periods(text)
      @tokens = scan_tokens(filtered_text)
    end

    def scan_tokens(text)
      text.scan(/[\S]+/)
    end

    def replace_periods(text)
      period = text.scan(PERIOD).first
      if period
        time_string = case period
                        when "@hourly"
                          "0 * * * *"
                        when "@daily"
                          "0 0 * * *"
                        when "@weekly"
                          "0 0 * * 0"
                        when "@monthly"
                          "0 0 1 * *"
                        when "@yearly"
                          "0 0 1 1 *"
                      end
        text.gsub(/^(#{PERIOD})/, time_string)
      else
        text
      end
    end

    def schedule_tokens
      @tokens.first(SCHEDULE_SIZE)
    end

    def command_tokens
      @tokens.last(@tokens.size - SCHEDULE_SIZE)
    end

    def execute
      Job.new Schedule.new(schedule_tokens: schedule_tokens, all_flag: @all_flag), Command.new(command_tokens)
    end

    class Command
      def initialize(data)
        if data.is_a?(Array)
          @command_tokens = data
        else
          @_string = data
        end
      end

      def get
        @_string ||= @command_tokens.join(' ')
      end

      def exist?
        @_string.size > 0
      end
    end

    # Class to store parsed time fields values
    class Schedule

      def initialize(opts={})
        @schedule_tokens = opts[:schedule_tokens]
        @all_flag = opts[:all_flag].nil? ? true : opts[:all_flag]

        @_minutes   = opts[:minutes]
        @_hours     = opts[:hours]
        @_days      = opts[:days]
        @_months    = opts[:months]
        @_weekdays  = opts[:weekdays]
      end

      def minutes
        @_minutes ||= TimeParser.new(@schedule_tokens.first, :minute, @all_flag).result
      end

      def hours
        @_hours ||= TimeParser.new(@schedule_tokens.second, :hour, @all_flag).result
      end

      def days
        @_days ||= TimeParser.new(@schedule_tokens.third, :day, @all_flag).result
      end

      def months
        @_months ||= TimeParser.new(@schedule_tokens.fourth, :month, @all_flag).result
      end

      def weekdays
        @_weekdays ||= TimeParser.new(@schedule_tokens.fifth, :weekday, @all_flag).result
      end

      %w[minutes hours days months weekdays].each do |method|
        define_method "#{method}_string" do
          result = send(method)
          result.is_a?(Array) ? result.join(', ') : result.to_s
        end
      end
    end

    # Class to parse time fields from crontab line.
    class TimeParser
      DIGIT   = /\d{1,2}/
      ALL     = /\*/
      COMMA   = /\,/
      DASH    = /\-/
      RANGE   = /#{DIGIT}#{DASH}#{DIGIT}/
      DEVIDE  = /#{ALL}\/#{DIGIT}|#{RANGE}\/#{DIGIT}/
      DEVIDER = /\//

      def tokens
        @tokens
      end

      # if all_flag is true -> return :all result if all?
      def initialize(time_expression, time_type, all_flag=true)
        @time_type = time_type
        @tokens = time_expression.scan(/#{COMMA}|#{DEVIDE}|#{RANGE}|#{DIGIT}|#{ALL}/)
        @all_flag = all_flag
      end

      def ast
        @_ast ||= expression
      end

      def result
        unique = ast.flatten.uniq
        unique.pop if unique.last.nil? #remove nil element
        if all?(unique) && @all_flag
          :all
        else
          unique
        end
      end

      def min_time_value
        @_min_time_value ||= case @time_type
                               when :minute
                                 0
                               when :hour
                                 0
                               when :day
                                 1
                               when :month
                                 1
                               when :weekday
                                 0
                             end
      end

      def max_time_value
        @_max_time_value ||= case @time_type
                               when :minute
                                 59
                               when :hour
                                 23
                               when :day
                                 31
                               when :month
                                 12
                               when :weekday
                                 6
                             end
      end

      private

      def next_token
        @tokens.shift
      end

      def next_token_safe
        @tokens.first
      end

      def second_token_safe
        @tokens.second
      end

      def expression
        token = next_token

        case token
          when nil
            return nil
          when DEVIDE
            return [devide(token), expression]
          when RANGE
            return [range(token), expression]
          when DIGIT
            return [digit(token), expression]
          when ALL
            return [all(token), expression]
          when COMMA
            return expression
          else
            raise "Unknown token: #{token}!"
        end
      end

      def digit(token)
        return token
      end

      def all(token)
        return (min_time_value..max_time_value).to_a
      end

      def devide(token)
        case token
          when /#{RANGE}#{DEVIDER}#{DIGIT}/
            up, bottom = token.split(DEVIDER)
            range(up).select do |x|
              x % bottom.to_i == 0
            end
          when /#{ALL}#{DEVIDER}#{DIGIT}/
            up, bottom = token.split(DEVIDER)
            (min_time_value..max_time_value).select do |x|
              x % bottom.to_i == 0
            end
        end
      end

      def range(token)
        min, max = token.split(DASH)
        (min..max).to_a
      end

      def correct?(array)
        array.all? { |el| el <= max_time_value } and array.all? { |el| el >= min_time_value }
      end

      def all?(array)
        array.count-1 == max_time_value-min_time_value
      end

    end
  end
end
