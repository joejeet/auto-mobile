class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!, :user_logged_in
  

  def index
    @session = SettingsSession.where("user_id= ?", current_user.id)
    @files = SettingsFile.where("company_id= ?", current_user.company_id)

          
    respond_to do |format|
     format.html # show.html.erb
     format.json  { render json: @session }
    end
    
  end
 
  # Handles when the user is kicked out of un-authorized area  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied."
    redirect_to root_url
  end  

  
  # To check if user just logged in and show settings modal 
  def user_logged_in
    if session[:just_logged_in] && !current_user.is_admin 
       gon.display_login_popup = true
    
       session[:just_logged_in] = false
    end
  end

def save_session_settings
    
    if session[:global_company_setting]
       current_session = GlobalCompanySetting.find(session[:global_company_setting])  
       current_session_id = current_session.settings_session_id 
    end

    if !current_session_id.blank?
        new_file = SettingsFile.new(:name => Time.now.to_s(:full), :company_id => current_user.company_id, :user_id => current_user.id)
        new_file.save

         
        current_session.update_attribute(:settings_file_id, new_file.id)
        current_session.update_attribute(:settings_session_id, nil)
        current_session.save
        session[:global_company_setting] = GlobalCompanySetting.find(session[:global_company_setting]).id
        
        SettingsSession.find(current_session_id).destroy
    end

    redirect_to root_path

end

def save_session_file
    
    if session[:global_company_setting]
       current_session = GlobalCompanySetting.find(session[:global_company_setting])
       current_session_id = current_session.settings_session_id 
    end

    if !current_session_id.blank?
        update_file = SettingsFile.find_by_name(:name => params[:setting][:name])
                
        setting = GlobalCompanySetting.find_by_settings_file_id(update_file.id)
        setting.update_attribute(:settings_file_id, update_file.id)
        setting.update_attribute(:settings_session_id, nil)
        setting.save
        session[:global_company_setting] = GlobalCompanySetting.find(session[:global_company_setting]).id
        
        SettingsSession.find(current_session_id).destroy
    end

    redirect_to root_path

end

  
    
end
