class CoffeeEngine < Sinatra::Base
  set :views, File.dirname(__FILE__) + '/assets/coffeescript'

  get '/javascripts/application.js' do
    coffee :application
  end
end