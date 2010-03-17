class TagsController < ApplicationController
  def index
    @tags = Tag.all
  end
  
  def new
    @tag = Tag.new
  end
  
  def create
    @tag = Tag.new(params[:tag])
    if @tag.save
      flash[:notice] = "El tema de interés se creó correctamente."
      redirect_to tags_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @tag = Tag.find(params[:id])
  end
  
  def update
    @tag = Tag.find(params[:id])
    if @tag.update_attributes(params[:tag])
      flash[:notice] = "El tema de interés se actualizó correctamente."
      redirect_to tags_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    flash[:notice] = "El tema de interés ha sido eliminado correctamente."
    redirect_to tags_url
  end
end
