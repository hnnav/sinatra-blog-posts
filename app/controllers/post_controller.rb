class PostController < ApplicationController

    # CREATE - render new form
    get "/posts/new" do
        redirect_if_not_logged_in
        erb :'posts/new'
    end

    # CREATE - create instance
    post "/posts" do
        redirect_if_not_logged_in
        
        unless Post.valid_params?(params)
            redirect to "/posts/new"
        else
            @post = Post.create(
            title: params[:title], 
            content: params[:content],
            user_id: @current_user.id
            )
            redirect "/posts/#{@post.id}"
        end
    end

     # READ - all posts
    get "/posts" do
        redirect_if_not_logged_in
        @posts = Post.all
        erb :'posts/index'
    end

    # READ - one post
    get "/posts/:id" do
        redirect_if_not_logged_in
        @post = Post.find(params[:id])
        erb :'posts/show'
    end

    # UPDATE - render edit form
    get "/posts/:id/edit" do
        redirect_if_not_logged_in
        @post = Post.find(params[:id])
        erb :'posts/edit'
    end

    # UPDATE - save instance
    patch "/posts/:id" do
        redirect_if_not_logged_in

        unless Post.valid_params?(params)
            redirect to "/posts/edit"
        end

        @post = Post.find(params[:id])
        if @post.user_id == current_user.id
            @post.update(params.select{|k|k=="title" || k=="content"})
            redirect "/posts/#{@post.id}"
        else redirect "/"
        end
    end

    # DELETE 
    delete "/posts/:id" do
        redirect_if_not_logged_in
        Post.destroy(params[:id])
        redirect "/users/#{current_user.id}"
    end  
end