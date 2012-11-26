module SmrDrilldownsHelper
@services_total_arr =[]
def contract_months(vehicle)
        return session[:vehicles].find{|v| v[:fi_code] == vehicle.fi_code}[:months]
end

def contract_miles(vehicle)
        return session[:vehicles].find{|v| v[:fi_code] == vehicle.fi_code}[:miles]
end

def wear_parts_vehicle(vehicle)
        return vehicle.service_plans.fixed.calculate_profile_total_cost(contract_miles(vehicle), contract_months(vehicle))['wear_parts'][0].uniq
end

def check_service_part(service)
        return service.service_parts.collect(&:part_id)
end

def  check_service(vehicle, id)
        return  vehicle.service_plans.fixed.calculate_profile_total_cost(contract_miles(vehicle), contract_months(vehicle))['contract_service_array'][0][id]
end

def  check_service_labour(vehicle, id)
     return  vehicle.service_plans.fixed.calculate_profile_total_cost(contract_miles(vehicle), contract_months(vehicle))['services'][0][id].labour
end

def  check_service_labour_cost(vehicle, id)
     return  vehicle.service_plans.fixed.calculate_profile_total_cost(contract_miles(vehicle), contract_months(vehicle))['service_labour_cost'][0][id]
end

def  check_service_total_cost(vehicle, i)
 #@services_total_arr<<(check_service_labour_cost(vehicle, i)+ ((vehicle.sump_capacity).to_i* 5.5)+check_service_parts_smr_rate(vehicle, i).inject(0, :+))
  return  check_service_labour_cost(vehicle, i)+ ((vehicle.sump_capacity).to_i* 5.5)+ (check_service_parts_smr_rate(vehicle, i).inject(0, :+))
end

def  check_service_parts_smr_rate(vehicle, i)
return vehicle.service_plans.fixed.calculate_profile_total_cost(contract_miles(vehicle), contract_months(vehicle))['service_parts_smr_rate'][0][i][0]
end 

end
