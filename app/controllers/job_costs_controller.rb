class JobCostsController < ApplicationController

def index
end


def search_vehicle

  if !params[:vin_imports][:vrm].blank?

    vin_record = VinImport.where("vin = ?", params[:vin_imports][:vrm]) 
    vrm_record = VinImport.where("vrm = ?", params[:vin_imports][:vrm])
    record = vin_record | vrm_record
  end
  
      @vehicle = nil
      @vehicle_vin = nil

      if !record.blank?
      vehicles = ServicePlan.find_by_smr_code(record[0].smr_profile).vehicles
     
      vehicles.each do |vehicle|
       if vehicle.trim ==  record[0].trim
          @vehicle = vehicle      
       end
      end 

      if @vehicle.blank?
          @vehicle_vin = record[0]
      end

      @service = []
      @parts = []

       #@vehicle.service_plans.fixed.calculate_profile_total_cost(36000, 60).each do |part|
       # @parts << Part.find(part) 
      #end    

       #@vehicle.service_plans.fixed.calculate_profile_total_cost(36000, 60).each do |part|
       # @service << Part.find(part)
       #end  
    end
    
    render :template => 'job_costs/search_vehicle'
end


def job_drilldown
    @details = Vehicle.find(params[:id])
    respond_to do |format|
        format.html { render action: "search_vehicle"  }
        format.js
      end
    
end

end
