class HomeController < ApplicationController

def index
    @session = SettingsSession.where("user_id= ?", current_user.id)
    @files = SettingsFile.where("company_id= ?", current_user.company_id)
  
    respond_to do |format|
     format.html # show.html.erb
     format.json  { render json: @settings }
    end
end



def settings_manager
end

    

end
