class CommentsController < ApplicationController
  
  skip_before_filter  :require_user, :except => :destroy
  
  layout "application_new"
  
  def index
    @bill = find_commentable
    @comments = @bill.comments
  end
  
  def new
    @comment = Comment.new
  end
  
  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])
    if verify_recaptcha(:model => @comment, :message => "Tienes un error en el código de seguridad") && @comment.save
      flash[:notice] = "El comentario fue enviado correctamente"
      redirect_to @commentable
    else
      render :action => "new"
    end
  end
  
  def destroy
    authorize! :destroy, Comment
    @commentable = find_commentable
    @comment = @commentable.comments.find(params[:id])
    
    @comment.destroy
    flash[:notice] = "El comentario ha sido eliminado"
    redirect_to @commentable
  end
  
  private

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
