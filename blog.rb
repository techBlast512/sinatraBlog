require 'dm-core'
require 'dm-migrations'

configure :development do
	DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

class Blog
	include DataMapper::Resource
	property :id, Serial
	property :title, String
	property :content, Text
	property :length, Integer
	property :released_on, Date

	def released_on=date
		super Date.strptime(date, '%m/%d/%Y')
	end
end

DataMapper.finalize

get '/blogs' do
	@blogs = Blog.all
	erb :blogs
end

get '/blogs/new' do
	halt(401, 'Not Authorized') unless session[:admin]
	@blog = Blog.new
	erb :new_blog
end

get '/blogs/:id' do
	@blog = Blog.get(params[:id])
	erb :show_blog
end

post '/blogs' do
	blog = Blog.create(params[:blog])
	redirect to("/blogs/#{blog.id}")
end

get '/blogs/:id/edit' do
	halt(401, 'Not Authorized') unless session[:admin]
	@blog = Blog.get(params[:id])
	erb :edit_blog
end

put '/blogs/:id' do
	halt(401, 'Not Authorized') unless session[:admin]
	blog = Blog.get(params[:id])
	blog.update(params[:blog])
	redirect to("/blogs/#{blog.id}")
end

delete '/blogs/:id' do
	halt(401, 'Not Authorized') unless session[:admin]
	Blog.get(params[:id]).destroy
	redirect to('/blogs')
end














