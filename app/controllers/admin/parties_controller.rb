module Admin
  class PartiesController < BaseController
    
    load_and_authorize_resource
    
    def index
      @parties = Party.all
    end
  
    def new
    end
  
    def create
      if @party.save
        flash[:notice] = "Se creó correctamente el partido político."
        redirect_to admin_parties_path
      else
        render :action => 'new'
      end
    end
  
    def edit
    end
  
    def update
      if @party.update_attributes(params[:party])
        flash[:notice] = "Se actualizó correctamente el partido político."
        redirect_to admin_parties_path
      else
        render :action => 'edit'
      end
    end
  
    def destroy
      @party.destroy
      flash[:notice] = "Se eliminó el partico correctamente."
      redirect_to admin_parties_path
    end
  end
end