module Colonel
  class Job

    attr_reader :id, :schedule, :command

    def initialize(schedule, command)
      @schedule = schedule
      @command = command

      increase_amount
      @id = @@amount
    end

    def self.clear_amount
      @@amount = 0
    end

    def update(opts={})
      @schedule = Parser::Schedule.new(opts[:schedule])
      @command  = Parser::Command.new(opts[:command])

      self
    end

    private

    def increase_amount
      @@amount = @@amount ? @@amount+1 : 1
    end
  end
end