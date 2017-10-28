class SessionsController < ApplicationController
  def create
    begin
      user = User.from_omniauth(env["omniauth.auth"])
      logger.debug "set user_id in session to <%s>" % user.email
      session[:user_id] = user.id
      redirect_to root_path
    rescue => e
      logger.error e
      flash[:notice] = "please login with @berkeley.edu email"
      redirect_to root_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
