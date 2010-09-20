module Admin
  class StatesController < BaseController
    
    load_and_authorize_resource
    
    def index
      @states = State.all
    end
  
    def show
    end
  
    def new
    end
  
    def create
      if @state.save
        flash[:notice] = "El estado fue creado correctamente."
        redirect_to admin_states_path
      else
        render :action => 'new'
      end
    end
  
    def edit
    end
  
    def update
      if @state.update_attributes(params[:state])
        flash[:notice] = "El estado fue actualizado correctamente."
        redirect_to admin_states_path
      else
        render :action => 'edit'
      end
    end
  
    def destroy
      @state.destroy
      flash[:notice] = "El estado ha sido eliminado correctamente."
      redirect_to admin_states_path
    end
  end
end