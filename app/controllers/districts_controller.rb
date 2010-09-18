class DistrictsController < ApplicationController
  
  skip_before_filter  :require_user
  
  def index
    respond_to do |wants|
      wants.html { 
        @state = State.find(params[:state_id])
        if params[:section].blank?
          redirect_to root_path(:state_id => params[:state_id])
          flash[:error] = "Por favor ingrese la sección que viene en su credencial de Elector"
        else
          @section = @state.sections.find_by_number(params[:section])
          if @section
            if current_user
              current_user.section = @section
              current_user.save
            end
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
        end
      }
      wants.js {
        @districts = District.find_all_by_state_id(params[:state_id])
      }
    end

  end

end
