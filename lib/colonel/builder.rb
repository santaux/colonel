# @example
# builder = Colonel::Builder.new
# jobs = builder.parse
module Colonel
  class Builder
    def initialize(opts={})
      Job.clear_amount
      @all_flag = opts[:all_flag].nil? ? true : opts[:all_flag]
    end

    # Gets the current user and use it to operate with crontab.
    def user
      @_user ||= `whoami`.chomp
    end

    # Returns crontab object.
    def crontab
      @_crontab ||= Crontab.new(user)
    end

    # Launchs current crontab parsing.
    def parse
      @jobs ||= []
      crontab.reject_useless.each do |line|
        @jobs << Parser.new(line, :all_flag => @all_flag).execute
      end
      @jobs
    end

    # Updates crontab file with current jobs.
    def update_crontab
      crontab.update(@jobs)
    end

    # Returns a job with specified index
    # @param (Integer) id is index of the job into @jobs array
    def find_job(id)
      @jobs.select { |j| j.id == id.to_i }.first
    end

    def get_job_index(id)
      @jobs.each_with_index { |j,i| return i if j.id == id.to_i }
    end

    # Replace job with specified id
    # @param (Integer) :id is index of the job into @jobs array
    # TODO: Refactor it! To complicated!
    def update_job(opts={})
      index = get_job_index(opts[:id])
      job = find_job(opts[:id])
      @jobs[index] = job.update(opts)
    end

    # Adds a job to @jobs array
    # @param (Parser::Schedule) :schedule is object of Parser::Schedule class
    # @param (Parser::Command) :command is object of Parser::Command class
    def add_job(opts={})
      @jobs << Job.new( Parser::Schedule.new(opts[:schedule]), Parser::Command.new(opts[:command]))
    end

    # Destroy job from @jobs array
    def destroy_job(id)
      index = get_job_index(id)
      @jobs.delete_at index
    end
  end
end
