class SessionsController < ApplicationController

  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      flash[:success] = "You have successfuly logged in"
      session[:user_id] = user.id
      redirect_to user_path(user)
    else
      flash.now[:danger] = "The username and password provided were not accepted"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have logged out."
    redirect_to root_path
  end
end