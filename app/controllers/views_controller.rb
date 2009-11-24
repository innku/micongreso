class ViewsController < ApplicationController
  def index
    @views = Views.all
  end
end
