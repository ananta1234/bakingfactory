  class SessionsController < ApplicationController
    def new
    end
    
    def create
      user = User.authenticate(params[:username], params[:password])
      if user
        session[:user_id] = user.id
        redirect_to home_path, notice: "Logged in!"
      else
        flash.now.alert = "Username and/or password is invalid"
        render "new"
      end
    end
    
    def destroy
      session[:user_id] = nil
      redirect_to home_path, notice: "Logged out!"
    end

    def self.authenticate(username,password)
      find_by_username(username).try(:authenticate, password)
    end
  end