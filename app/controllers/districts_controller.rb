class DistrictsController < ApplicationController
  
  skip_before_filter  :login_required
  
  def index
    respond_to do |wants|
      wants.html { 
        @state = State.find(params[:state_id])
        @section = @state.sections.find_by_number(params[:section])
        if @section
          @district = @section.district
          @member = @district.member
          if @member
            redirect_to @member
            #flash[:notice] = "Si quieres conocer los diputados plurinominales de tu región <a href='/regions/#{@state.region.id}'>haz click aquí</a>"
          end
        else
          redirect_to root_path(:state_id => params[:state_id])
          flash[:error] = "No encontramos la sección #{params[:section]} en el estado de #{@state.name}"
        end
      }
      wants.js {
        @districts = District.find_all_by_state_id(params[:state_id])
      }
    end

  end

end
