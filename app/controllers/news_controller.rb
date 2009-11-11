class NewsController < ApplicationController
  def index
    @news = News.all
  end
  
  def show
    @news = News.find(params[:id])
  end
  
  def new
    @news = News.new
  end
  
  def create
    @news = News.new(params[:news])
    if @news.save
      flash[:notice] = "La noticia se creó correctamente."
      redirect_to news_index_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @news = News.find(params[:id])
  end
  
  def update
    @news = News.find(params[:id])
    if @news.update_attributes(params[:news])
      flash[:notice] = "La noticia se actualizó correctamente."
      redirect_to news_index_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @news = News.find(params[:id])
    @news.destroy
    flash[:notice] = "Successfully destroyed news."
    redirect_to news_url
  end
end
