require 'rubygems'
require 'haml'
require 'action_view'
require 'sinatra'
require 'coffee-script'

lib = File.expand_path('../../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'colonel'
require 'colonel/server/coffee_engine'
require 'colonel/server/helpers/roots_helper'
require 'colonel/server/helpers/templates_helper'
require 'colonel/server/helpers/views_helper'

#class Server < Sinatra::Base

  use CoffeeEngine
  use Rack::MethodOverride

  dir = File.dirname(File.expand_path(__FILE__))

  set :views,  "#{dir}/server/views"
  set :public_folder, "#{dir}/server/public"

  helpers RootsHelper, TemplatesHelper, ViewsHelper

  before /^(?!\/index)/ do
    @colonel = Colonel::Builder.new(:all_flag => false)
    @jobs = @colonel.parse
  end

  before /^(?!\/(index|new|create))/ do
    @job = @colonel.find_job(params[:id])
  end

  get '/' do
    @colonel = Colonel::Builder.new(:all_flag => true)
    @jobs = @colonel.parse

    haml :index
  end

  get '/edit/:id' do
    @job = @colonel.find_job(params[:id])
    haml :edit
  end

  get '/new' do
    haml :new
  end

  post '/' do
    @colonel.add_job(params)
    @colonel.update_crontab

    redirect '/'
  end

  put '/:id' do
    @colonel.update_job(params)
    @colonel.update_crontab

    redirect '/'
  end

  delete '/:id' do
    @colonel.destroy_job(params[:id])
    @colonel.update_crontab

    redirect '/'
  end
#end

#Server.run!
