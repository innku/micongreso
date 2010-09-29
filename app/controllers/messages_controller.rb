class MessagesController < ApplicationController
  
  before_filter :find_member
  skip_before_filter :require_user, :only => [:create, :new]
  
  def index
    @messages = @member.messages
  end
  
  def new
    options = {}
    options = {:name => current_user.name, :email => current_user.email} if current_user
    @message = Message.new(options)
    render :layout => false
  end
  
  def create
    @message = @member.messages.build(params[:message])
    if verify_recaptcha(:model => @message, :message => "Tienes un error en el código de seguridad") && @message.save
      flash[:notice] = "Se ha enviado el mensaje."
      redirect_to success_member_message_path(@member, @message)
    else
      render :action => 'new', :layout => false
    end
  end
  
  def success
    render :layout => false
  end
  
  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    flash[:notice] = "El mensaje se ha eliminado correctamente."
    redirect_to messages_url
  end
  
  def find_member
    @member = Member.find(params[:member_id])
  end
end
