class NewsController < ApplicationController
  
  skip_before_filter :require_user, :only => [:index, :show]
  
  def index
    if params[:search]
      @news = News.title_or_body_like(params[:search]).paginate(:page => params[:page])
    else
      @news = News.ordered.paginate(:page => params[:page])
    end
    @popular_news = News.popular
  end
  
  def show
    @news = News.find(params[:id])
    @related_news = @news.find_related_tags
    @news.viewed!
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
    params[:news][:tag_list] ||= []
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
    flash[:notice] = "La noticia se eliminó correctamente."
    redirect_to news_index_url
  end
end
