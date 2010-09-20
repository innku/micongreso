module Admin
  class TermsController < BaseController
    
    load_and_authorize_resource
    
    def index
      @terms = Term.all
    end
  
    def show
    end
  
    def new
    end
  
    def create
      if @term.save
        flash[:notice] = "Legislación creada correctamente"
        redirect_to admin_terms_path
      else
        render :action => 'new'
      end
    end
  
    def edit
    end
  
    def update
      if @term.update_attributes(params[:term])
        flash[:notice] = "La Legislación fue actualizada correctamente."
        redirect_to admin_terms_path
      else
        render :action => 'edit'
      end
    end
  
    def destroy
      @term.destroy
      flash[:notice] = "La legislación se eliminó correctamente."
      redirect_to admin_terms_path
    end
  end
end