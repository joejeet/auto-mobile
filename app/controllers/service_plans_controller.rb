class ServicePlansController < ApplicationController
  load_and_authorize_resource

  respond_to :html, :json, :js
  def clone
    @part_descriptions = PartDescription.all
    vehicle = session[:list_vehicles_id]
    vehicle = Vehicle.find(vehicle).first
    if vehicle.blank? || vehicle.service_plans.count >= 2
      redirect_to "/service_plans/filter_vehicles?clone_service_plan=#{clone_service_plan.id}"
    else
      @list_vehicles = vehicle
      @manufacturer  = vehicle.manufacturer.id
      clone_service_plan = ServicePlan.find(params[:id])
      @service_plan = clone_service_plan.generate_clone
      @service_plan.smr_code = @service_plan.generate_smr(vehicle)
      respond_to do |format|
        format.html { render action: "new" }
      end
    end
  end
  
  def models_search   
  respond_to do |format|
  format.js
      model = MakeModel.where("manufacturer_id=? and country_id=?",params[:manufacturer], params[:country])
      @vehicles_model_for_dropdown = model.map{|a| [a.model, a.id]}.insert(0, "Select a Model")
   end
  end
  
  def vehicles_search
    vehicle_array
      respond_to do |format|
      format.js       
        vehicles = Vehicle.where("make_model_id=? and country_id=?",params[:model], params[:country])
        model = params[:model]
        if !vehicles.blank?
          vehicles.group_by{|l| l.body_style}.each do |key,value|
            @vehicles_body_style_for_dropdown = @vehicles_body_style_for_dropdown<<[key, key, {:class => model}]
          end
          vehicles.group_by{|l| l.fuel_type}.each do |key,value|
            @vehicles_fuel_type_for_dropdown = @vehicles_fuel_type_for_dropdown<<[key, key, {:class => model}]
            end
            vehicles.group_by{|l| l.doors}.each do |key,value|
            @vehicles_doors_for_dropdown = @vehicles_doors_for_dropdown<<[key, key, {:class => model}]
            end
            vehicles.group_by{|l| l.engine_cc}.each do |key,value|
            @vehicles_engine_cc_for_dropdown = @vehicles_engine_cc_for_dropdown<<[key, key, {:class => model}]
            end
            vehicles.group_by{|l| l.cylinders}.each do |key,value|            
            @vehicles_cylinders_for_dropdown = @vehicles_cylinders_for_dropdown<<[key, key, {:class => model}]
            end
            vehicles.group_by{|l| l.power_bhp}.each do |key,value|
            @vehicles_power_bhp_for_dropdown = @vehicles_power_bhp_for_dropdown<<[key, key, {:class => model}]
            end
            vehicles.group_by{|l| l.transmission}.each do |key,value|
            @vehicles_transmission_for_dropdown = @vehicles_transmission_for_dropdown<<[key, key, {:class => model}]
            end
            vehicles.group_by{|l| l.number_of_gears}.each do |key,value|
            @vehicles_number_of_gears_for_dropdown = @vehicles_number_of_gears_for_dropdown<<[key, key, {:class => model}]
            end
            vehicles.group_by{|l| l.driven_wheels}.each do |key,value|
            @vehicles_driven_wheels_for_dropdown = @vehicles_driven_wheels_for_dropdown<<[key, key, {:class => model}]
            end
            vehicles.group_by{|l| l.model_year}.each do |key,value|
            @vehicles_model_year_for_dropdown = @vehicles_model_year_for_dropdown<<[key, key, {:class => model}]
            end
           
      end
    end
  end
  
  def filter_vehicles
    @clone_service_plan = ServicePlan.find(params[:clone_service_plan]) if params[:clone_service_plan]
    vehicle_array
    @manufacturers = Manufacturer.all
    @manufacturers.each do |manufacturer|
      @manufacturers_for_dropdown = @manufacturers_for_dropdown << [manufacturer.name, manufacturer.id]
      if !manufacturer.make_models.blank?
      manufacturer.make_models.group_by{|l| l.country.id}.each do |key,value|
        country_name = Country.find(key)
        @vehicles_country_for_dropdown = @vehicles_country_for_dropdown << [country_name.name, key, {:class => manufacturer.id}]
       
        end
      end
    end
  end

  def selected_profile_vehicles
    if !params[:manufacturer_name].blank? and !params[:country_name].blank? and !params[:make_model].blank? and !params[:body_style].blank? and !params[:fuel_type].blank? and !params[:doors].blank? and !params[:engine_cc].blank? and !params[:cylinders].blank? and !params[:power_bhp].blank? and !params[:transmission].blank? and !params[:number_of_gears].blank? and !params[:driven_wheels].blank? and !params[:model_year].blank?
      @list_vehicles = Vehicle.filter_vehicles_and(params[:manufacturer_name],params[:country_name], params[:make_model], params[:body_style], params[:fuel_type], params[:doors], params[:engine_cc], params[:cylinders], params[:power_bhp], params[:transmission], params[:number_of_gears], params[:driven_wheels], params[:model_year])
            
      if !@list_vehicles.blank?
        session[:list_vehicles_id] = []
        session[:list_vehicles_id] << @list_vehicles.first.id
          if params[:clone_service_plan]
              @clone_service_plan = ServicePlan.find(params[:clone_service_plan])
              redirect_to clone_service_plan_url("#{@clone_service_plan.id}")
          else
              redirect_to  new_service_plan_path
          end
      elsif(!params[:clone_service_plan].blank?)
          @clone_service_plan = ServicePlan.find(params[:clone_service_plan])
           redirect_to "/service_plans/filter_vehicles?clone_service_plan=#{@clone_service_plan.id}"
      else
          redirect_to '/service_plans/filter_vehicles'
      end

   elsif(!params[:clone_service_plan].blank?)
      @clone_service_plan = ServicePlan.find(params[:clone_service_plan])
      redirect_to "/service_plans/filter_vehicles?clone_service_plan=#{@clone_service_plan.id}"
   else
      redirect_to '/service_plans/filter_vehicles'
   end

  end

  def part_search
    respond_to do |format|
      format.js {
        @part = Part.joins(:manufacturer_parts, :part_numbers).where("part_description_id=? AND part_type=? AND part_number=? AND manufacturer_id=?", params[:description], params[:type], params[:num], params[:manufacturer]).first

        if @part.nil?
          @remote = true
          @part = Part.new
          @part.manufacturer_parts.build
          @part.manufacturer_parts.each do |manufacturer|
            manufacturer.manufacturer_id = params[:manufacturer]
          end
          @part.part_numbers.each do |part_no|
            part_no.part_number = params[:num]
          end
          @part.part_description_id =params[:description]
          render :new_part
        else
          @part_json = @part.to_json(:only => [ :id, :select_part_number, :part_description_id, :labour_time, :interval_miles, :interval_months, :ll_interval_miles, :ll_interval_months, :calculate_price])
          render :select_part
        end
      }
      format.any { render :text => "Invalid format", :status => 403 }
    end
  end

  def search
    @service_plan = find_service_plan
  end

  def index
    filter_vehicles
    if(!params[:service_plan].nil?)
      @service_plan = ServicePlan.find_all_by_smr_code(params[:service_plan])
    end
  end

  def new
     vehicle = session[:list_vehicles_id]
    vehicles = Vehicle.find(vehicle)
    @vehicle = vehicles.first
    @manufacturer  = @vehicle.manufacturer.id
    if @vehicle.blank?
      redirect_to service_plans_filter_vehicles_path
    else
       @service_plan = ServicePlan.new
      @service_plan.smr_code = @service_plan.generate_smr(@vehicle)
      if @vehicle.service_plans.count >= 2
        redirect_to service_plans_filter_vehicles_path
      end
      @service_plan.services.build
      @service_plan.fixed_costs.build

      PartDescription.all.each do |descr|
        @service_plan.profile_parts << ProfilePart.new({:part_description => descr})
      end
    #@service_plan.parts.build
    end
  end

  def create
    @part_descriptions = PartDescription.all
    vehicle = session[:list_vehicles_id]
    vehicles = Vehicle.find(vehicle)
    @vehicle = vehicles.first
    @manufacturer  = @vehicle.manufacturer.id
    params[:service_plan][:manufacturer] = @manufacturer
    params[:service_plan][:model] = @vehicle.make_model.id

    @service_plan = ServicePlan.new(params[:service_plan])

    @service_plan.vehicles = vehicles
    @service_plan.smr_code = @service_plan.generate_smr(@vehicle)
    if @vehicle.service_plans.count >= 2
      redirect_to service_plans_filter_vehicles_path
    else
      if @service_plan.fixed == "Fixed"
        @service_plan.smr_code += "F"
      else
      @service_plan.smr_code += "V"
      end

      if @service_plan.save
        session[:list_vehicles_id] = nil
        respond_with @service_plan
      else
        if @service_plan.profile_parts.blank?
          PartDescription.all.each do |descr|
            @service_plan.profile_parts << ProfilePart.new({:part_description => descr})
          end
        end
        #  @service_plan.parts.build if @service_plan.parts.blank?
        @service_plan.fixed_costs.build if @service_plan.fixed_costs.blank?
        @service_plan.services.build if @service_plan.services.blank?
        render :action => 'new'
      end
    end
  end

  def show
    @service_plan = ServicePlan.find(params[:id])
  end

  def edit
      @service_plan = ServicePlan.find(params[:id])
      @vehicle = Vehicle.where("make_model_id =?", @service_plan.model ).first
      @manufacturer = @vehicle.manufacturer.id
  end

  def update
    @service_plan = ServicePlan.find(params[:id])
       respond_to do |format|
      if @service_plan.update_attributes(params[:service_plan])
        format.html { redirect_to @service_plan, notice: 'Service Plan was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @service_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  
  def vehicle_array
   @manufacturers_for_dropdown = []
    @vehicles_model_for_dropdown  =[]  
    @vehicles_body_style_for_dropdown = []
     @vehicles_fuel_type_for_dropdown = []
     @vehicles_doors_for_dropdown = []
     @vehicles_engine_cc_for_dropdown = []
     @vehicles_cylinders_for_dropdown = []
     @vehicles_power_bhp_for_dropdown = []
     @vehicles_transmission_for_dropdown = []
     @vehicles_number_of_gears_for_dropdown = []
     @vehicles_driven_wheels_for_dropdown = []
     @vehicles_model_year_for_dropdown = []
     @vehicles_country_for_dropdown  =[]
  end

  def find_service_plan
    ServicePlan.joins(:vehicles => :manufacturer).where( conditions )
  end

  def manufacturer_conditions
    ["manufacturer_id = ?", params[:manufacturer_name]] unless params[:manufacturer_name].blank?
  end

  def model_conditions
    ["make_model_id = ?", params[:make_model]] unless params[:make_model].blank?
  end

  def body_style_conditions
    ["body_style = ?", params[:body_style]] unless params[:body_style].blank?
  end

  def fuel_type_conditions
    ["fuel_type = ?", params[:fuel_type]] unless params[:fuel_type].blank?
  end

  def doors_conditions
    ["doors = ?", params[:doors]] unless params[:doors].blank?
  end

  def engine_cc_conditions
    ["engine_cc = ?", params[:engine_cc]] unless params[:engine_cc].blank?
  end

  def cylinders_conditions
    ["cylinders = ?", params[:cylinders]] unless params[:cylinders].blank?
  end

  def power_bhp_conditions
    ["power_bhp = ?", params[:power_bhp]] unless params[:power_bhp].blank?
  end

  def transmission_conditions
    ["transmission = ?", params[:transmission]] unless params[:transmission].blank?
  end

  def number_of_gears_conditions
    ["number_of_gears = ?", params[:number_of_gears]] unless params[:number_of_gears].blank?
  end

  def driven_wheels_conditions
    ["driven_wheels = ?", params[:driven_wheels]] unless params[:driven_wheels].blank?
  end

  def model_year_conditions
    ["model_year = ?", params[:model_year]] unless params[:model_year].blank?
  end

  def conditions
    [conditions_clauses.join(' AND '), *conditions_options]
  end

  def conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end

  def conditions_options
    conditions_parts.map { |condition| condition[1..-1] }.flatten
  end

  def conditions_parts
    private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
  end
end
