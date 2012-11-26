class MakeModelsController < ApplicationController
    load_and_authorize_resource
    
    respond_to :html, :json, :js
  
  
  def search
    if(!params[:make_model].nil?)
      @make_model = MakeModel.find_by_model(params[:make_model])

      if(!@make_model.nil?)
        respond_with !@make_model, :location => @make_models_url
      else
        @make_model = MakeModel.new
        render new_make_model_path
      end
    end
  end

  def index
     if(!params[:make_model].blank?)
      @make_model = MakeModel.search(params[:make_model])
    else
      @make_model = MakeModel.all
    end
  end

  def create
    @make_model = MakeModel.new(params[:make_model])

     @make_model.save
    respond_with @make_model, :location => make_models_url
  end

  def new
    @make_model = MakeModel.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  def show
    @make_model = MakeModel.find(params[:id])
  end

  def edit
    @make_model = MakeModel.find(params[:id])
  end

  def update
    @make_model = MakeModel.find(params[:id])

      respond_to do |format|
      if @make_model.update_attributes(params[:make_model])
        format.html { redirect_to @make_model, notice: 'make_model was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @make_model.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @make_model = MakeModel.find(params[:id])
    @make_model.destroy

    respond_to do |format|
      format.html { redirect_to make_models_url }
      format.json { head :no_content }
    end
  end
end
