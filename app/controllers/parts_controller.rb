class PartsController < ApplicationController
  load_and_authorize_resource

  respond_to :html, :json, :js
  
  
  def search
    if(!params[:part].nil?)
      @part = Part.find_by_part_number(params[:part])

      if(!@part.nil?)
        respond_with @part, :location => parts_url
      else
        @part = Part.new
        render new_part_path
      end
    end
  end

  def index
     if(!params[:part].blank?)
      @part = Part.search(params[:part])
    else
      @part = Part.all
    end
  end

  def create
    @part = Part.new(params[:part])
kkk
    @remote = true if request.xhr?

    if @part.save
      if request.xhr?
        @part_json = @part.to_json(:only => [ :id, :part_number, :part_description_id, :labour_time, :interval_miles, :interval_months, :ll_interval_miles, :ll_interval_months, :price])
        render :created
      else
        respond_with @part, :location => parts_url
      end
    else
      render :new
    end
  end

  def new
    @part = Part.new
    @part.manufacturer_parts.build
    @part.part_numbers.build
    
    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  def show
    @part = Part.find(params[:id])
  end

  def edit
    @part = Part.find(params[:id])
  end

  def update
    @part = Part.find(params[:id])

    # @part.update_attributes(params[:part])
    respond_to do |format|
      if @part.update_attributes(params[:part])
        format.html { redirect_to @part, notice: 'Part was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @part = Part.find(params[:id])
    @part.destroy

    respond_to do |format|
      format.html { redirect_to parts_url }
      format.json { head :no_content }
    end
  end
end
