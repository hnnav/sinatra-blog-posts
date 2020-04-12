require './config/environment'
require "./app/models/user"

class UserController < ApplicationController

    # render login form
    get '/users/login' do 
        if logged_in?   
           redirect "/users/#{current_user.id}"  
        else
           erb :'/users/login'
        end 
    end 

    # set user and session
    post '/users/login' do 
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password])
           session[:user_id] = @user.id 
           redirect "/users/#{@user.id}"
        else  
           redirect "/users/login"
        end 
    end 

    # show user account page (users/show)
    get '/users/:id' do
        if logged_in?
            @user = User.find(params[:id]) 
            erb :'users/show'
        else
            redirect "/users/signup"
        end
    end

    # render signup form
    get '/signup' do
        if !session[:user_id]
          erb :'users/signup'
        else
          redirect to "/users/#{current_user.id}"
        end
    end

    # create user instance, set session
    post '/signup' do
        if User.find_by(username: params[:username])
            flash[:alert] = "Username is already taken"
            redirect '/signup'
        elsif params[:username] == "" || params[:password] == ""
            flash[:alert] = "Please choose username and password"
            redirect '/signup'
        elsif params[:password] == params[:password_confirmation]
            user = User.create(username: params[:username], password: params[:password])
            session[:user_id] = user.id
            redirect to "/users/#{user.id}"
        else
            flash[:alert] = "Passwords don't match!"
            redirect '/signup'
        end
    end

    # logout method
    get '/logout' do
        if session[:user_id] != nil
          session.destroy
          redirect to '/'
        end
    end
end