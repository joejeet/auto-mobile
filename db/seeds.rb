# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# Values in lookup-table for User Types

basic_user_type = UserType.create(user_type_name: 'Maintenance Control')
elevated_user_type = UserType.create(user_type_name: "Pricing Only /Pricing & Maintenance Control")

# Default Company

default_company = Company.create( Name: 'Keyworth Automotive', addressline1: 'Grange Farm', addressline2: 'Garthorpe', City: 'Leicestershire', postcode: 'LE14 2SJ', Telephone: '08445 499224')

# Default Customer

default_customer = Company.create( Name: 'EuropCar', addressline1: '40 Corporation Street', City: 'Sheffield', postcode: 'S3 8RP', Telephone: '01142 754111')  


# Default Admin User

user = User.create(username: 'admin', email: 'admin@kwa.com', password: 'password', password_confirmation: 'password', user_type_id: elevated_user_type.id, company_id: default_company.id, is_admin: true)

# Front-end User: Customer

user = User.create(username: 'customer', email: 'customer@kwa.com', password: 'password', password_confirmation: 'password', user_type_id: elevated_user_type.id, company_id: default_customer.id, is_admin: false)


# Countries
#country = Country.create(name: 'United Kingdom', country_code: 'UK')


# Regions
region = Region.create(name: 'national average', country_id: '224')


# Global SMR settings

settings = GlobalCompanySetting.create(country_id: '224', region_id: '1', lpg: '79.8', cost_per_litre_petrol: '142.9', cost_per_litre_diesel: '138.9', tyre_life_premium: '100', tyre_life_mid: '100', tyre_life_budget: '100', tyre_cost_premium: '100', tyre_cost_mid: '100', tyre_cost_budget: '100', last_service_exclusion_within_miles: '1000', last_service_exclusion_within_percentage: '100', last_service_exclusion_within_month: '1', optimize_service_cost_for_fixed_variable: false, optimize_service_cost_for_package_price: true, MOT_one_month_early: true, tyres_cost: 'Cost', tyres_ppm: 'ppm', valve_replacement: '2.50', balance: '4.50')


# Default Inflation values

inflation = Inflation.create(fuel_y1: '0', fuel_y2: '0', fuel_y3: '0', fuel_y4: '0', fuel_y5: '0', fuel_above_y5: '0', labour_y1: '0', labour_y2: '0', labour_y3: '0', labour_y4: '0', labour_y5: '0', labour_above_y5: '0', oil_y1: '0', oil_y2: '0', oil_y3: '0', oil_y4: '0', oil_y5: '0', oil_above_y5: '0', parts_y1: '0', parts_y2: '0', parts_y3: '0', parts_y4: '0', parts_y5: '0', parts_above_y5: '0', tyres_y1: '0', tyres_y2: '0', tyres_y3: '0', tyres_y4: '0', tyres_y5: '0', tyres_above_y5: '0', country_id: '224', region_id: '1')

# Front-end User: Maintenance

user = User.create(username: 'maintenance', email: 'maintenance@kwa.com', password: 'password', password_confirmation: 'password', user_type_id: basic_user_type.id, company_id: default_customer.id, is_admin: false)






