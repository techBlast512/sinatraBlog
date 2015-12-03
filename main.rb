require 'sinatra'
require './blog'
require 'rack-google-analytics'
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
	@title = "Ruby Me, Please | Login"
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

def set_title
	@title ||= "Collin's Ruby Blog" # uses Ruby conditional assignment operator ||=
end

before do
	set_title
end

get '/logout' do
	@title = "Logout"
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
	@title = "Ruby Me, Please | Home"
	erb :home
end

get '/about' do
	@title = "Ruby Me, Please | About"
	erb :about
end

get '/contact' do
	@title = "Ruby Me, Please | Contact"
	erb :contact
end

not_found do
	@title = "Page Not Found"
	erb :not_found
end

get '/fake-error' do
	status 500
	"Don't worry, it's under control."
end


