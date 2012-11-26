class GlobalCompanySettingsController < ApplicationController

  
def index
   user_session = SettingsSession.find_by_user_id(current_user.id)

  if !user_session.blank?
     @setting = GlobalCompanySetting.find_by_settings_session_id(user_session.id).dup
     session[:global_company_setting] =  GlobalCompanySetting.find_by_settings_session_id(user_session.id).id
  
  else 
     @setting = GlobalCompanySetting.first.dup
     session[:global_company_setting] =  GlobalCompanySetting.first.id
  end

end

  
def create

    
   file = SettingsFile.find_by_name_and_company_id(params[:setting][:name], current_user.company_id)
      
    
  if params[:setting][:name].blank?
    user_session = SettingsSession.new(:user_id => current_user.id)
    user_session.save

    @setting = GlobalCompanySetting.new(params[:global_company_setting], :country_id => '224')
    @setting.update_attribute(:settings_session_id, user_session.id)
    @setting.save

    session[:global_company_setting] = @setting.id
    render action: "index"
    

    elsif file.blank?
    new_file = SettingsFile.new(:name => params[:setting][:name], :company_id => current_user.company_id, :user_id => current_user.id)
    new_file.save

    @setting = GlobalCompanySetting.new(params[:global_company_setting])
    @setting.update_attribute(:settings_file_id, new_file.id)
    @setting.save
    render action: "index"

    else 
    @setting = GlobalCompanySetting.find_by_settings_file_id(file.id)
    @setting.update_attributes(params[:global_company_setting])
    render action: "index"
  end           
   
end


def edit
  @setting = GlobalCompanySetting.find(params[:id])
end


def update
  @setting = GlobalCompanySetting.find(params[:id])

  respond_to do |format|
     if @setting.update_attributes(params[:global_company_setting])
        format.html { render action: "index", notice: 'Settings was successfully updated'}
        format.json { head :ok }
     else
        format.html { render action: "edit" }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
     end
  end
end


def list
  
  @session = SettingsSession.where("user_id= ?", current_user.id)
  @files = SettingsFile.where("company_id= ?", current_user.company_id)

  
   respond_to do |format|
     format.html # show.html.erb
     format.json  { render json: @settings }
   end
end


end


