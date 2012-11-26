class VehiclesController < ApplicationController
  load_and_authorize_resource

  respond_to :html, :json, :js
  
  def country_code_dropdown(manufacturer)
    @country_code_for_dropdown = []
    @models_for_dropdown = []
      manufacturer.make_models.group_by{|l| l.country.id}.each do |key,value|
        country_name = Country.find(key)
        @country_code_for_dropdown = @country_code_for_dropdown <<[country_name.name, key]
        value.each do |val|
        @models_for_dropdown = @models_for_dropdown << [val.model, val.id, {:class => key}]
        end
     
     end
  end
                                                                      
  def search
    @manufacturer = Manufacturer.find(params[:manufacturer_id])
    if(!params[:vehicle].blank?)
      @vehicle = Vehicle.search(params[:vehicle])
      if !@vehicle.blank?
        redirect_to manufacturer_vehicle_path(@manufacturer,@vehicle)
      end
    else
      redirect_to manufacturer_vehicles_path(@manufacturer)
    end
  end

  def index
    @manufacturer = Manufacturer.find(params[:manufacturer_id])
    if(!params[:vehicle].blank?)
      @vehicle = Vehicle.search(params[:vehicle])
    else
      @vehicle = @manufacturer.vehicles
    end
  end

  def new
    @vehicle = Vehicle.new
    @manufacturer = Manufacturer.find(params[:manufacturer_id])
      country_code_dropdown(@manufacturer)
      
  end

  def create
    @manufacturer = Manufacturer.find(params[:manufacturer_id])
    country_code_dropdown(@manufacturer)
    @vehicle = Vehicle.new(params[:vehicle])
    
    if @vehicle.save
      redirect_to manufacturer_vehicles_path(@manufacturer)
    else
      respond_with @vehicle, :location=> new_manufacturer_vehicle_path
    end
  end

  def edit
    @vehicle = Vehicle.find(params[:id])
    @manufacturer = Manufacturer.find(params[:manufacturer_id])
    country_code_dropdown(@manufacturer)
  end

  def update
    @vehicle = Vehicle.find(params[:id])
    @manufacturer = Manufacturer.find(params[:manufacturer_id])
    country_code_dropdown(@manufacturer)
    if @vehicle.update_attributes(params[:vehicle])
      redirect_to manufacturer_vehicles_path(@manufacturer)
    else
      respond_with @vehicle, :location=> edit_manufacturer_vehicle_path
    end
  end

  def show
    @manufacturer = Manufacturer.find(params[:manufacturer_id])
    @vehicle = @manufacturer.vehicles.find(params[:id])

  end

  def destroy
    @manufacturer = Manufacturer.find(params[:manufacturer_id])
    @vehicle = @manufacturer.vehicles.find(params[:id])
    @vehicle.destroy

    respond_to do |format|
      format.html { redirect_to manufacturer_vehicles_path(@manufacturer) }
      format.json { head :no_content }
    end
  end
  
  
end
