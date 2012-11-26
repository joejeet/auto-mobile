class PartDescriptionsController < ApplicationController
  load_and_authorize_resource
  
  def search
    if(params[:description].present?)
      @descriptions = PartDescription.where("LOWER(description) like ?", "%#{params[:description].downcase}%")
    end
    
    render :index
  end
  
  def index
    @description = PartDescription.all
  end

  def new
    @description = PartDescription.new
  end

  def create
    @description = PartDescription.new(params[:part_description])
    if @description.save
      flash[:notice] = "Part description created"
      redirect_to(@description)
    else
      render :action => :new
    end
  end
  
  def show
    @description = PartDescription.find(params[:id])
    render :edit
  end

  def edit
    @description = PartDescription.find(params[:id])
  end

  def update
    @description = PartDescription.find(params[:id])

    if @description.update_attributes(params[:part_description])
      flash[:notice] = "Part description was successfully updated."
      redirect_to(@description)
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @description = PartDescription.find(params[:id])
    @description.destroy

    redirect_to part_descriptions_url
  end
end
