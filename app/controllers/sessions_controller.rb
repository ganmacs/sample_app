class SessionsController < ApplicationController

  before_action :sign_in?

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def new

  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
