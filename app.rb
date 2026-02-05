require 'sinatra'
require 'slim'
require 'sqlite3'
require 'sinatra/reloader'
require 'bcrypt'

set :public_folder, File.dirname(__FILE__) + '/public'

get '/' do
	@title = 'Home'
	slim :index
end

get '/marketplace' do
	@title = 'Marketplace'
	slim :marketplace
end

get '/forum' do
	@title = 'Forum'
	slim :forum
end

get '/shop' do
	@title = 'Shop'
	slim :shop
end