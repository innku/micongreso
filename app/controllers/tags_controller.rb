class TagsController < ApplicationController
  
  skip_before_filter :require_user, :only => :show
  
  def index
    @tags = ActsAsTaggableOn::Tag.all
  end
  
  def new
    @tag = ActsAsTaggableOn::Tag.new
  end
  
  def show
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @bills = Bill.tagged_with(@tag.name)
  end
  
  def create
    @tag = ActsAsTaggableOn::Tag.new(params[:tag])
    if @tag.save
      flash[:notice] = "El tema de interés se creó correctamente."
      redirect_to tags_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
  end
  
  def update
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    if @tag.update_attributes(params[:tag])
      flash[:notice] = "El tema de interés se actualizó correctamente."
      redirect_to tags_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @tag.destroy
    flash[:notice] = "El tema de interés ha sido eliminado correctamente."
    redirect_to tags_url
  end
end
