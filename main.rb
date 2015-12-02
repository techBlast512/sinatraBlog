require 'sinatra'
require './blog'
require 'sinatra/reloader' if development?

set :public_folder, 'assets'
set :views, 'templates'

configure :development do
	DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
	DataMapper.setup(:default, ENV['DATABASE_URL'])
end

set :session_secret, 'itsGonnaBeHardToCrackThisOne'

get '/login' do
	erb :login
end

post '/login' do
	if params[:username] == settings.username && params[:password] == settings.password
		session[:admin] = true
		redirect to('/blogs')
	else	
		erb :login
	end	
end

configure do
	enable :sessions
	set :username, 'collinStubb512'
	set :password, 'gitItOnUp512'
end

get '/logout' do
	session.clear
	redirect to('/login')
end

get '/set/:name' do
	session[:name] = params[:name]
end

get '/get/hello' do
	"Hello #{session[:name]}"
end

get '/' do
	erb :home
end

get '/about' do
	@title = "About This Website"
	erb :about
end

get '/contact' do
	@title = "Contact Me"
	erb :contact
end

not_found do
	@title = "It's a 404"
	erb :not_found
end

get '/fake-error' do
	status 500
	"Don't worry, it's under control."
end


