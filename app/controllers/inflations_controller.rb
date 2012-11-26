class InflationsController < ApplicationController

def index
   #user_session = SettingsSession.find_by_user_id(current_user.id)

  if !user_session.blank?
     if setting = Inflation.find_by_settings_session_id(user_session.id)
        @inflation = setting.dup
        session[:inflation_setting] =  Inflation.find_by_settings_session_id(user_session.id).id
     end 
  
  else 
     @inflation = Inflation.first.dup
     session[:inflation_setting] =  Inflation.first.id
  end

end

  
def create

    
   file = SettingsFile.find_by_name_and_company_id(params[:inflation][:name], current_user.company_id)
      
    
  if params[:inflation][:name].blank?
    user_session = SettingsSession.new(:user_id => current_user.id)
    user_session.save

    @inflation = Inflation.new(params[:inflation_setting])
    @inflation.update_attribute(:settings_session_id, user_session.id)
    @inflation.save

    session[:inflation_setting] = @inflation.id
    render action: "index"
    

    elsif file.blank?
    new_file = SettingsFile.new(:name => params[:inflation][:name], :company_id => current_user.company_id, :user_id => current_user.id)
    new_file.save

    @inflation = Inflation.new(params[:inflation_setting])
    @inflation.update_attribute(:settings_file_id, new_file.id)
    @inflation.save
    render action: "index"

    else 
    @inflation = Inflation.find_by_settings_file_id(file.id)
    @inflation.update_attributes(params[:inflation_setting])
    render action: "index"
  end           
   
end


def edit
  @inflation = Inflation.find(params[:id])
end


def update
  @inflation = Inflation.find(params[:id])

  respond_to do |format|
     if @inflation.update_attributes(params[:inflation_setting])
        format.html { render action: "index", notice: 'Settings was successfully updated'}
        format.json { head :ok }
     else
        format.html { render action: "edit" }
        format.json { render json: @inflation.errors, status: :unprocessable_entity }
     end
  end
end


def list
  
  @session = SettingsSession.where("user_id= ?", current_user.id)
  @files = SettingsFile.where("company_id= ?", current_user.company_id)

  
   respond_to do |format|
     format.html # show.html.erb
     format.json  { render json: @inflation }
   end
end


end
