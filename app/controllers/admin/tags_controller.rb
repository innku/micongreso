module Admin
  class TagsController < BaseController
    
    before_filter :find_or_build_tag
    authorize_resource :class => ActsAsTaggableOn::Tag
    
    def index
      @tags = ActsAsTaggableOn::Tag.all
    end
  
    def new
    end
  
    def show
      @bills = Bill.tagged_with(@tag.name)
    end
  
    def create
      if @tag.save
        flash[:notice] = "El tema de interés se creó correctamente."
        redirect_to admin_tags_path
      else
        render :action => 'new'
      end
    end
  
    def edit
    end
  
    def update
      if @tag.update_attributes(params[:acts_as_taggable_on_tag])
        flash[:notice] = "El tema de interés se actualizó correctamente."
        redirect_to admin_tags_path
      else
        render :action => 'edit'
      end
    end
  
    def destroy
      @tag.destroy
      flash[:notice] = "El tema de interés ha sido eliminado correctamente."
      redirect_to admin_tags_path
    end
    
    private
    
    def find_or_build_tag
      if ["new", "create"].include?(action_name)
        @tag = ActsAsTaggableOn::Tag.new(params[:acts_as_taggable_on_tag])
      elsif ["edit", "show", "update", "destroy"].include?(action_name)
        @tag = ActsAsTaggableOn::Tag.find(params[:id])
      end
    end
  end
end