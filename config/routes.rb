FiDataTool::Application.routes.draw do
  
  resources :users
  devise_for :user, :path => '', :path_names => { :sign_in => "login", :sign_out => "logout"}

  get "uploads/index"

  match "save_session_settings" => 'application#save_session_settings'
  match "save_session_file" => 'application#save_session_file'
  
  match 'users/sign_up' => redirect('/404.html')
  root :to => "home#index"
  match "smr_drilldowns/add_vehicle_to_popup" => 'smr_drilldowns#add_vehicle_to_popup'
  match "settings_manager" => 'home#settings_manager'
  match "uploads" => 'uploads#upload'
  match "service_plans/models_search" => 'service_plans#models_search'
  match "service_plans/vehicles_search" => 'service_plans#vehicles_search'
  match "service_plans/search" => 'service_plans#search'
  match "service_plans/vehicles" => 'service_plans#vehicles'
  match "service_plans/filter_vehicles" => 'service_plans#filter_vehicles'
  match "service_plans/selected_profile_vehicles" => 'service_plans#selected_profile_vehicles'
  match "service_plans/cloned" => 'service_plans#cloned'
  match "manufacturers/search" => 'manufacturers#index'
  match "manufacturers/list" => 'manufacturers#list'
  
  match "parts/search" => 'parts#index'
  match "make_models/search" => 'make_models#index'

  resources :settings_managers

  
  resources :smr_drilldowns
  post 'search_vehicle' => 'smr_drilldowns#search_vehicle'
  get 'search_vehicle' => 'smr_drilldowns#index'

  resources :job_costs
  post 'job_search' => 'job_costs#search_vehicle'
  get 'job_search' => 'job_costs#index'

    
  resources :inflations
  match "inflations" => 'inflations#index'
  

  resources :global_company_settings
  match "settings" => 'global_company_settings#index'
  match "settings_list" => 'global_company_settings#list'

  

  
  resources :companies
  match 'companies/:company_id/users' => 'users#for_company', :as => :company_users
  
  
  resources :service_plans do  
    get 'clone', :on => :member
     collection do
      get 'part_search'
     end
  end
  
  resources :manufacturers do
    resources :vehicles
    match "vehicles/search" => 'vehicles#index'
  end
  resources :parts
  resources :make_models
  
  resources :part_descriptions do
    collection do
      get 'search'
    end
  end

# The priority is based upon order of creation:
# first created -> highest priority.

# Sample of regular route:
#   match 'products/:id' => 'catalog#view'
# Keep in mind you can assign values other than :controller and :action

# Sample of named route:
#   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
# This route can be invoked with purchase_url(:id => product.id)

# Sample resource route (maps HTTP verbs to controller actions automatically):
#   resources :products

# Sample resource route with options:
#   resources :products do
#     member do
#       get 'short'
#       post 'toggle'
#     end
#
#     collection do
#       get 'sold'
#     end
#   end

# Sample resource route with sub-resources:
#   resources :products do
#     resources :comments, :sales
#     resource :seller
#   end

# Sample resource route with more complex sub-resources
#   resources :products do
#     resources :comments
#     resources :sales do
#       get 'recent', :on => :collection
#     end
#   end

# Sample resource route within a namespace:
#   namespace :admin do
#     # Directs /admin/products/* to Admin::ProductsController
#     # (app/controllers/admin/products_controller.rb)
#     resources :products
#   end

# You can have the root of your site routed with "root"
# just remember to delete public/index.html.
# root :to => 'welcome#index'

# See how all your routes lay out with "rake routes"

# This is a legacy wild controller route that's not recommended for RESTful applications.
# Note: This route will make all actions in every controller accessible via GET requests.
# match ':controller(/:action(/:id))(.:format)'
end
