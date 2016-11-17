class RemediesController < ApplicationController

  def import

    Remedy.import(params[:file])

    # Product.products_to_firebase(current_location)
    redirect_to remedies_path , notice: "Products imported."
  end

  def index
    @remedies = Remedy.all 
  end

  def show
    @remedy = Remedy.find(params[:id])
  end

  def new
    @remedy = Remedy.new
  end

  def edit
    @remedy = Remedy.find(params[:id])
  end

  def create
    @remedy = Remedy.new(remedy_params)
    
    if @remedy.save
      redirect_to remedies_path
    end
  end

  def update
    @remedy = Remedy.find(params[:id])

    if @remedy.update_attributes(remedy_params)
      redirect_to remedies_path
    end
  end

  def destroy
    @remedy = Remedy.find(params[:id])
    @remedy.destroy
    redirect_to remedies_path
  end

  def remedy_params
	# params.require(:remedy).permit(:name, :lab_name, :lab_cod,:lab_price,:max_price,:code,:generic,:active_principle)
  end

end
