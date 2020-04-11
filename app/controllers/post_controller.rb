require './config/environment'
require "./app/models/user"
require "./app/models/post"

class PostController < ApplicationController

    get "/posts" do
        @posts = Post.all
        erb :'posts/index'
    end

    get "/posts/new" do
        @post = Post.new
        erb :'posts/new'
    end

    post "/posts" do
        @post = Post.create(params)
        redirect to "/posts/#{@post.id}"
    end

    get "/posts/:id" do
        @post = Post.find(params[:id])
        erb :'posts/show'
    end

    get "/posts/:id/edit" do
        @post = Post.find(params[:id])
        erb :'posts/edit'
    end

    patch "/posts/:id" do
        @post = Post.find(params[:id])
        @post.update(params[:Post])
        redirect to "/posts/#{ @post.id }"
    end

    delete "/posts/:id" do
        Post.destroy(params[:id])
        redirect to "/users/#{current_user.id}"
    end
    
end