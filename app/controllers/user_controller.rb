require './config/environment'
require "./app/models/user"

class UserController < ApplicationController

    # render login form
    get '/users/login' do 
        if !session[:user_id]
          erb :'users/login'
        else
          redirect "/users/#{@current_user.id}"
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

    # render signup form
    get '/users/signup' do
        if !session[:user_id]
            erb :'/users/signup'
        else
            redirect "/users/#{@current_user.id}"
        end
    end

    # create user instance, set session
    post '/users/signup' do
        if params[:username] == "" || params[:password] == ""
            redirect to '/users/signup'
        elsif params[:password] == params[:password_confirmation]
            @user = User.create(
             username: params[:username], 
             password: params[:password]
            )
            session[:user_id] = @user.id 
            redirect "/users/#{@user.id}"
        else
            "passwords don't match"
        end
    end

    # logout method
    get '/logout' do
        if session[:user_id] != nil
          session.destroy
          redirect to '/login'
        else
          redirect to '/'
        end
    end
end