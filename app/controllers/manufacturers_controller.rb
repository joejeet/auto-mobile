class ManufacturersController < ApplicationController
  load_and_authorize_resource

  respond_to :html, :json, :js
  
  def list
    @manufacturer = Manufacturer.search_all
    render 'index'
  end

  def index
    if(!params[:manufacturer].blank?)
      @manufacturer = Manufacturer.search(params[:manufacturer])
    end
  end

  # GET /manufacturers/1
  # GET /manufacturers/1.json
  def show
    @manufacturer = Manufacturer.find(params[:id])


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @manufacturer }
    end
  end

  # GET /manufacturers/new

  # GET /manufacturers/new.json
  def new
    @manufacturer = Manufacturer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @manufacturer }
    end
  end

  # GET /manufacturers/1/edit

  def edit
    @manufacturer = Manufacturer.find(params[:id])
  end

  # POST /manufacturers

  # POST /manufacturers.json
  def create
    @manufacturer = Manufacturer.new(params[:manufacturer])
    @manufacturer.save

    respond_with @manufacturer
  end

  # PUT /manufacturers/1
  # PUT /manufacturers/1.json
  def update
    @manufacturer = Manufacturer.find(params[:id])

    @manufacturer.update_attributes(params[:manufacturer])
    respond_with @manufacturer
  end


  # DELETE /manufacturers/1
  # DELETE /manufacturers/1.json
  def destroy
    @manufacturer = Manufacturer.find(params[:id])
    @manufacturer.destroy

    respond_to do |format|
      format.html { redirect_to manufacturers_url }
      format.json { head :no_content }
    end
  end
end
