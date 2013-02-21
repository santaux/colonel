# example:
# builder = Colonel::Builder.new
# jobs = builder.parse
module Colonel
  class Builder
    def initialize(opts={})
      Job.clear_amount
      @all_flag = opts[:all_flag].nil? ? true : opts[:all_flag]
    end

    def user
      @_user ||= `whoami`.chomp
    end

    def crontab
      @_crontab ||= Crontab.new(user)
    end

    def parse
      @jobs ||= []
      crontab.reject_useless.each do |line|
        @jobs << Parser.new(line, :all_flag => @all_flag).execute
      end
      @jobs
    end

    def update_crontab
      crontab.update(@jobs)
    end

    def find_job(id)
      @jobs.select { |j| j.id == id.to_i }.first
    end

    def get_job_index(id)
      @jobs.each_with_index { |j,i| return i if j.id == id.to_i }
    end

    # TODO: Refactor it! To complicated!
    def update_job(opts={})
      index = get_job_index(opts[:id])
      job = find_job(opts[:id])
      @jobs[index] = job.update(opts)
    end

    def add_job(opts={})
      @jobs << Job.new( Parser::Schedule.new(opts[:schedule]), Parser::Command.new(opts[:command]))
    end

    def destroy_job(id)
      index = get_job_index(id)
      @jobs.delete_at index
    end
  end
end
