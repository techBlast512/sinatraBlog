require 'dm-core'
require 'dm-migrations'

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

module BlogHelpers
	def find_blogs
		@blogs = Blog.all
	end

	def find_blog
		Blog.get(params[:id])
	end

	def create_blog
		@blog = Blog.create(params[:blog])
	end
end

get '/blogs' do
	find_blogs
	erb :blogs
end

get '/blogs/new' do
	halt(401, 'Not Authorized') unless session[:admin]
	@blog = Blog.new
	erb :new_blog
end

get '/blogs/:id' do
	@blog = find_blog
	erb :show_blog
end

post '/blogs' do
	flash[:notice] = "Blog Post successfully added" if create_blog
	redirect to("/blogs/#{@blog.id}")
end

get '/blogs/:id/edit' do
	halt(401, 'Not Authorized') unless session[:admin]
	@blog = find_blog
	erb :edit_blog
end

put '/blogs/:id' do
	halt(401, 'Not Authorized') unless session[:admin]
	blog = find_blog
	blog.update(params[:blog])
	redirect to("/blogs/#{blog.id}")
end

delete '/blogs/:id' do
	halt(401, 'Not Authorized') unless session[:admin]
	find_blog.destroy
	redirect to('/blogs')
end














