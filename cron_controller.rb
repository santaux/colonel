require 'colonel'

class Admin::CronController < Admin::BaseController

  before_filter :get_colonel, :except => :index
  before_filter :get_jobs, :except => :index
  before_filter :get_job, :except => [:index, :new, :create]

  def index
    @colonel = Colonel.new(:all_flag => true)
    @jobs = @colonel.parse
  end

  def create
    @colonel.add_job(params)
    @colonel.update_crontab

    redirect_to :action => :index
  end

  def update
    @colonel.update_job(params)
    @colonel.update_crontab

    redirect_to :action => :index
  end

  def destroy
    @colonel.destroy_job(params[:id])
    @colonel.update_crontab

    redirect_to :action => :index
  end

  private

  def get_colonel
    @colonel = Colonel.new(:all_flag => false)
  end

  def get_jobs
    @jobs = @colonel.parse
  end

  def get_job
    @job = @colonel.find_job(params[:id])
  end
end
