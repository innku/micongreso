class TermsController < ApplicationController
  def index
    @terms = Term.all
  end
  
  def show
    @term = Term.find(params[:id])
  end
  
  def new
    @term = Term.new
  end
  
  def create
    @term = Term.new(params[:term])
    if @term.save
      flash[:notice] = "Successfully created term."
      redirect_to @term
    else
      render :action => 'new'
    end
  end
  
  def edit
    @term = Term.find(params[:id])
  end
  
  def update
    @term = Term.find(params[:id])
    if @term.update_attributes(params[:term])
      flash[:notice] = "Successfully updated term."
      redirect_to @term
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @term = Term.find(params[:id])
    @term.destroy
    flash[:notice] = "Successfully destroyed term."
    redirect_to terms_url
  end
end
