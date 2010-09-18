class UserSessionsController < ApplicationController
  
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Has entrado a MiCongreso, ¡Bienvenido de regreso!"
      redirect_back_or_default root_path
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    redirect_to root_path
  end
end
