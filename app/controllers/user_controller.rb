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
        @user = User.find(params[:id]) 
        erb :'users/show'
    end

    # render signup form
    get '/users/signup' do 
        if logged_in? 
           redirect "/users/#{current_user.id}"
        else
           erb :'/users/signup'        
        end 
    end 

    # create user instance, set session
    post '/users/signup' do
        if params[:username] == "" || params[:password] == ""
            # flash[:alert] = "Please enter username and password"
            redirect to "/users/signup"
        else 
            if params[:password] == params[:password_confirmation]
               @user = User.create(
                username: params[:username], 
                password: params[:password]
               )
               session[:user_id] = @user.id 
               redirect "/users/#{@user.id}" #users/show
            else 
               # flash[:alert] = "Passwords don't match - Please try again"
               redirect "/users/signup"
            end 
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