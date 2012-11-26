# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120913062352) do

  create_table "companies", :force => true do |t|
    t.string   "Name"
    t.string   "addressline1"
    t.string   "addressline2"
    t.string   "City"
    t.string   "postcode"
    t.string   "Telephone"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "active_status", :default => true
  end

  create_table "countries", :force => true do |t|
    t.text     "name",         :null => false
    t.text     "country_code", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "fixed_costs", :force => true do |t|
    t.integer  "service_plan_id",                               :null => false
    t.decimal  "menu_pricing",    :precision => 8, :scale => 2, :null => false
    t.integer  "miles"
    t.float    "multiply",                                      :null => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  add_index "fixed_costs", ["service_plan_id"], :name => "index_fixed_costs_on_service_plan_id"

  create_table "global_company_settings", :force => true do |t|
    t.integer  "country_id"
    t.integer  "settings_file_id"
    t.integer  "settings_session_id"
    t.integer  "region_id"
    t.decimal  "lpg"
    t.decimal  "cost_per_litre_petrol"
    t.decimal  "cost_per_litre_diesel"
    t.decimal  "tyre_life_premium"
    t.decimal  "tyre_life_mid"
    t.decimal  "tyre_life_budget"
    t.decimal  "tyre_cost_premium"
    t.decimal  "tyre_cost_mid"
    t.decimal  "tyre_cost_budget"
    t.integer  "last_service_exclusion_within_miles"
    t.decimal  "last_service_exclusion_within_percentage"
    t.integer  "last_service_exclusion_within_month"
    t.boolean  "optimize_service_cost_for_fixed_variable"
    t.boolean  "optimize_service_cost_for_package_price"
    t.boolean  "MOT_one_month_early"
    t.string   "tyres_cost"
    t.string   "tyres_ppm"
    t.decimal  "valve_replacement"
    t.decimal  "balance"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "inflations", :force => true do |t|
    t.decimal  "labour_y1"
    t.decimal  "labour_y2"
    t.decimal  "labour_y3"
    t.decimal  "labour_y4"
    t.decimal  "labour_y5"
    t.decimal  "labour_above_y5"
    t.decimal  "oil_y1"
    t.decimal  "oil_y2"
    t.decimal  "oil_y3"
    t.decimal  "oil_y4"
    t.decimal  "oil_y5"
    t.decimal  "oil_above_y5"
    t.decimal  "parts_y1"
    t.decimal  "parts_y2"
    t.decimal  "parts_y3"
    t.decimal  "parts_y4"
    t.decimal  "parts_y5"
    t.decimal  "parts_above_y5"
    t.decimal  "tyres_y1"
    t.decimal  "tyres_y2"
    t.decimal  "tyres_y3"
    t.decimal  "tyres_y4"
    t.decimal  "tyres_y5"
    t.decimal  "tyres_above_y5"
    t.decimal  "fuel_y1"
    t.decimal  "fuel_y2"
    t.decimal  "fuel_y3"
    t.decimal  "fuel_y4"
    t.decimal  "fuel_y5"
    t.decimal  "fuel_above_y5"
    t.integer  "country_id"
    t.integer  "region_id"
    t.integer  "settings_session_id"
    t.integer  "settings_file_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "make_models", :force => true do |t|
    t.integer  "manufacturer_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "country_id"
    t.string   "make_code"
    t.string   "model"
    t.string   "model_code"
  end

  add_index "make_models", ["country_id"], :name => "index_make_models_on_country_id"
  add_index "make_models", ["manufacturer_id"], :name => "index_make_models_on_manufacturer_id"

  create_table "manufacturer_parts", :force => true do |t|
    t.integer  "manufacturer_id", :null => false
    t.integer  "part_id",         :null => false
    t.float    "price"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "manufacturers", :force => true do |t|
    t.text     "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "code"
  end

  create_table "part_descriptions", :force => true do |t|
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "description"
    t.string   "below_300_wear_months"
    t.string   "above_300_wear_months"
    t.string   "lcv_wear_months"
    t.string   "off_road_wear_months"
    t.string   "below_300_wear_miles"
    t.string   "above_300_wear_miles"
    t.string   "lcv_wear_miles"
    t.string   "off_road_wear_miles"
  end

  create_table "part_numbers", :force => true do |t|
    t.integer  "part_id",     :null => false
    t.text     "part_number", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "parts", :force => true do |t|
    t.integer  "part_description_id",                                            :null => false
    t.float    "labour_time"
    t.integer  "interval_miles"
    t.text     "interval_months"
    t.integer  "ll_interval_miles"
    t.text     "ll_interval_months"
    t.string   "part_type",           :limit => 1,                               :null => false
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
    t.datetime "embargo_datetime"
    t.decimal  "price",                            :precision => 8, :scale => 2
    t.string   "part_number"
    t.string   "ancestry"
  end

  add_index "parts", ["ancestry"], :name => "index_parts_on_ancestry"
  add_index "parts", ["part_description_id"], :name => "index_parts_on_part_description_id"

  create_table "profile_parts", :force => true do |t|
    t.integer  "service_plan_id",                                  :null => false
    t.integer  "part_id",                                          :null => false
    t.float    "labour_time",                                      :null => false
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.integer  "interval_miles"
    t.text     "interval_months"
    t.integer  "ll_interval_miles"
    t.text     "ll_interval_months"
    t.decimal  "price",              :precision => 8, :scale => 2
  end

  add_index "profile_parts", ["part_id"], :name => "index_profile_parts_on_part_id"
  add_index "profile_parts", ["service_plan_id"], :name => "index_profile_parts_on_service_plan_id"

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "service_parts", :force => true do |t|
    t.integer  "service_id"
    t.integer  "part_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "service_plans", :force => true do |t|
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.datetime "embargo_datetime"
    t.string   "smr_code"
    t.integer  "interval_miles"
    t.integer  "interval_months"
    t.string   "fixed"
  end

  create_table "service_plans_vehicles", :id => false, :force => true do |t|
    t.integer "service_plan_id"
    t.integer "vehicle_id"
  end

  create_table "services", :force => true do |t|
    t.integer  "service_plan_id",                               :null => false
    t.text     "name",                                          :null => false
    t.float    "multiply",                                      :null => false
    t.decimal  "labour",          :precision => 8, :scale => 2, :null => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "miles"
    t.integer  "months"
  end

  add_index "services", ["service_plan_id"], :name => "index_services_on_service_plan_id"

  create_table "settings_files", :force => true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "settings_sessions", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tyres", :force => true do |t|
    t.string   "part_number",                                :null => false
    t.string   "manufacturer",                               :null => false
    t.string   "description",                                :null => false
    t.string   "tyre_type",                                  :null => false
    t.string   "vehicle_type"
    t.integer  "width",                                      :null => false
    t.integer  "profile",                                    :null => false
    t.string   "construction",                               :null => false
    t.integer  "diameter",                                   :null => false
    t.string   "speed_rating",                               :null => false
    t.string   "season",                                     :null => false
    t.string   "ef_rating"
    t.string   "wet_rating"
    t.string   "noise_rating"
    t.decimal  "price",        :precision => 8, :scale => 2, :null => false
    t.string   "file_date",                                  :null => false
    t.string   "supplier",                                   :null => false
    t.string   "status",                                     :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "user_types", :force => true do |t|
    t.string   "user_type_name"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "username"
    t.integer  "company_id"
    t.boolean  "active_status",          :default => true
    t.boolean  "is_admin",               :default => false
    t.integer  "user_type_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "vehicles", :force => true do |t|
    t.text     "fi_code",                 :null => false
    t.integer  "service_plan_id"
    t.text     "body_style",              :null => false
    t.text     "fuel_type",               :null => false
    t.integer  "doors",                   :null => false
    t.integer  "engine_cc",               :null => false
    t.integer  "cylinders",               :null => false
    t.integer  "power_bhp",               :null => false
    t.integer  "power_ps",                :null => false
    t.text     "transmission",            :null => false
    t.integer  "number_of_gears",         :null => false
    t.text     "driven_wheels",           :null => false
    t.text     "status",                  :null => false
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "make_model_id",           :null => false
    t.datetime "model_year",              :null => false
    t.text     "version"
    t.datetime "embargo_datetime"
    t.integer  "country_id"
    t.string   "warranty_miles"
    t.integer  "warranty_months"
    t.string   "trim"
    t.string   "front_tyre"
    t.string   "front_tyre_width"
    t.string   "front_tyre_profile"
    t.string   "front_tyre_type"
    t.string   "front_tyre_diameter"
    t.string   "front_tyre_speed_rating"
    t.string   "rear_tyre"
    t.string   "rear_tyre_width"
    t.string   "rear_tyre_profile"
    t.string   "rear_tyre_type"
    t.string   "rear_tyre_diameter"
    t.string   "rear_tyre_speed_rating"
    t.string   "sump_capacity"
    t.string   "gearbox_oil_capacity"
    t.string   "rear_diff_oil_capacity"
    t.string   "break_fluid_capacity"
  end

  add_index "vehicles", ["country_id"], :name => "index_vehicles_on_country_id"
  add_index "vehicles", ["make_model_id"], :name => "index_vehicles_on_make_model_id"

  create_table "vin_imports", :force => true do |t|
    t.string   "vin"
    t.string   "vrm"
    t.date     "reg_date"
    t.string   "country"
    t.string   "make_code"
    t.string   "model"
    t.integer  "engine_cc"
    t.integer  "power_ps"
    t.string   "body_style"
    t.integer  "doors"
    t.string   "fuel_type"
    t.integer  "cylinders"
    t.string   "transmission"
    t.integer  "number_of_gears"
    t.string   "driven_wheels"
    t.integer  "model_year"
    t.string   "status"
    t.string   "smr_profile"
    t.string   "trim"
    t.string   "honda_desc"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_foreign_key "fixed_costs", "service_plans", :name => "fixed_costs_service_plan_fk"

  add_foreign_key "make_models", "countries", :name => "make_models_country_fk"
  add_foreign_key "make_models", "manufacturers", :name => "make_models_manufacturer_fk"

  add_foreign_key "parts", "part_descriptions", :name => "parts_part_description_fk"

  add_foreign_key "profile_parts", "parts", :name => "profile_parts_part_fk"
  add_foreign_key "profile_parts", "service_plans", :name => "profile_parts_service_plan_fk"

  add_foreign_key "services", "service_plans", :name => "services_service_plan_fk"

  add_foreign_key "vehicles", "countries", :name => "vehicles_country_fk"
  add_foreign_key "vehicles", "make_models", :name => "vehicles_make_model_fk"

end
