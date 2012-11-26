# Be sure to restart your server when you modify this file.

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# FiDataTool::Application.config.session_store :active_record_store 

if ENV['TORQUEBOX_APP_NAME']
  FiDataTool::Application.config.session_store :torquebox_store
else
  FiDataTool::Application.config.session_store :cookie_store, :key => '_fi_data_tool_session'
end