class PresentationsController < ApplicationController
def index
    @presentations = Presentation.all 
  end

  def show
    @presentation = Presentation.find(params[:id])
  end

  def new
    @presentation = Presentation.new
  end

  def edit
    @presentation = Presentation.find(params[:id])
  end

  def create
    @presentation = Presentation.new(presentation_params)
    
    if @presentation.save
      redirect_to presentations_path
    end
  end

  def update
    @presentation = Presentation.find(params[:id])

    if @presentation.update_attributes(presentation_params)
      redirect_to presentations_path
   end
  end

  def destroy
    @presentation = Presentation.find(params[:id])
    @presentation.destroy
    redirect_to presentations_path
  end

  def presentation_params
	params.require(:presentation).permit(:presentation, :remedy_id)
  end

end
