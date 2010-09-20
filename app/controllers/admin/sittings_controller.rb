module Admin
  class SittingsController < BaseController
    
    before_filter :delete_related_bills
    load_and_authorize_resource
    
    def index
      @sittings = Sitting.all
    end
  
    def show
      @assistances = @sitting.assistances.include_member.present
      @absences = @sitting.assistances.include_member.absent
    end
  
    def new
      10.times { @sitting.absences.build }
    end
  
    def create
      if @sitting.save
        flash[:notice] = "Successfully created sitting."
        redirect_to admin_sittings_path
      else
        render :action => 'new'
      end
    end
  
    def edit
      @sitting = Sitting.find(params[:id])
    end
  
    def update
      if @sitting.update_attributes(params[:sitting])
        flash[:notice] = "Successfully updated sitting."
        redirect_to admin_sittings_path
      else
        render :action => 'edit'
      end
    end
  
    def destroy
      @sitting = Sitting.find(params[:id])
      @sitting.destroy
      flash[:notice] = "Successfully destroyed sitting."
      redirect_to admin_sittings_path
    end
    
    private
    def delete_related_bills
      params[:sitting][:bill_ids] ||= [] if ["create", "update"].include?(action_name)
    end
  end
end
