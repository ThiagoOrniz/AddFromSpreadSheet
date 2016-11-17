class RemediesController < ApplicationController

  def import

    Remedy.import(params[:file])

    # Product.products_to_firebase(current_location)
    redirect_to remedies_path , notice: "Products imported."
  end

  def index
    @remedies = Remedy.all 
  end

end
