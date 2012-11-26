class ServicePlanDetails

def self.total_cost
	return service_total = ServicePlan.calculate_all_total_costs	
end

end