module Admin
  class ActionsController < BaseController
    
    load_and_authorize_resource :bill
    before_filter :load_action
    authorize_resource :action, :through => :bill
    
    layout "application_new"
    
    def index
      @actions = Action.all
    end

    def show
    end

    def new
    end

    def edit
    end

    def create
      if @action.save
        redirect_to admin_bill_actions_path(@bill), :notice => 'La acción fue creada correctamente.'
      else
        render :action => "new"
      end
    end
    
    def update
      if @action.update_attributes(params[:action_object])
        redirect_to admin_bill_actions_path(@bill), :notice => 'La acción fue actualizada correctamente.'
      else
        render :action => "edit"
      end
    end

    def destroy
      @action.destroy
      redirect_to admin_bill_actions_path(@bill)
    end
    
    private
    def load_action
      if ["show", "edit", "update", "destroy"].include?(action_name)
        @action = @bill.actions.find(params[:id])
      elsif ["new", "create", ].include?(action_name)
        @action = @bill.actions.build(params[:action_object])
      end
    end
  end
end
