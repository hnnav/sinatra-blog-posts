require './config/environment'
require "./app/models/user"

class UserController < ApplicationController

    get '/users/signup' do
        erb :'/users/signup'
    end

    get '/users/login' do
        erb :'/users/login'
    end

    post '/users/signup' do
        if params[:password] == params[:password_confirmation]
            @user = User.create(
             username: params[:username], 
             password: params[:password]
            )
            session[:user_id] = @user.id 
            redirect "/users/#{@user.id}"
        end
    end

    get '/users/:id' do
        @user = User.find(params[:id]) 
        erb :'users/show'
    end

    post '/users/login' do 
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password])
           session[:user_id] = @user.id 
           redirect "/users/#{@user.id}"
        else  
           redirect "/users/login"
        end 
    end 

end