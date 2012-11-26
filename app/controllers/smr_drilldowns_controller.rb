class SmrDrilldownsController < ApplicationController
  before_filter :setup_defaults
  def index
    @vehicles =  Vehicle.joins(:service_plans).order('vehicles.created_at DESC').limit(5)
    session[:months] = nil
    session[:miles] = nil
    session[:vehicles] = []
  end

  def search_vehicle
    #Probably should not limit but page - Something for later
    @vehicles = Vehicle.joins(:service_plans).order('vehicles.created_at DESC').limit(5).scoped
    @vehicles =  @vehicles.joins(:make_model).where("model  ILIKE ?", @vehicle) if @vehicle.present?

    render "index"
  end

  def add_vehicle_to_popup
    #Initialize if needed
    session[:vehicles] ||= []

    #Rails.logger.info session
    #Rails.logger.info "Months: " + session[:months].to_s
    #Rails.logger.info "Miles: " + session[:miles].to_s
    
    #Stop duplicates
    unless session[:vehicles].any?{|v| v[:fi_code] == params[:code]} 
      session[:vehicles] << {:fi_code => params[:code], :months => session[:months], :miles => session[:miles]}
    end
    
    #Get FI codes
    fi_codes = session[:vehicles].map{|v| v[:fi_code]}
    
    respond_to do |format|
      format.js     
      @vehicles = Vehicle.where("fi_code IN (?)",fi_codes)
    end
  end

  protected

  def setup_defaults
    if params[:search]
      @miles = (params[:search][:miles]).to_i
      @months = (params[:search][:months]).to_i
      @vehicle = params[:search][:vehicle]
    end

    @miles ||= 60000
    @months ||= 36
    @vehicle ||= ''
    
    session[:miles] = @miles
    session[:months] = @months
    
    #Rails.logger.info "Months: " + session[:months].to_s
    #Rails.logger.info "Miles: " + session[:miles].to_s
  end
end