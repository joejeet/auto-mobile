require 'csv'

class UploadsController < ApplicationController
  
  # To prevent un-authorized access  
  authorize_resource :class => :controller
  
  def upload
    if request.post? && params[:file].present?
      process_file(params[:file])
    end
  end

  private

  def process_file(file)
    make_model_dataset(file)  if file.original_filename.end_with?("Model.csv") # Checking the code in file name
    country_code_dataset(file) if file.original_filename.end_with?("Country Code.csv") # Checking the code in file name
    new_car_dataset(file) if file.original_filename.end_with?("New Car Dataset v5.csv") # Checking the code in file name
    smr_dataset(file) if file.original_filename.end_with?("HONDA SMR(Completed).csv") # Checking the code in file name
    wear_parts_rates(file) if file.original_filename.end_with?("Parts Wear Rates.csv") # Checking the code in file name
    vin_import(file) if file.original_filename.end_with?("VIN Import.csv") # Checking the code in file name
    tyre_import(file) if file.original_filename.end_with?("trye_import.csv") # Checking the code in file name
  end
  
  def wear_parts_rates(file)
    infile = file.read
    n = 0
    CSV.parse(infile) do |row|
      n += 1      
      next if n==63 or n==1 or n==2 or n==3 or n==4 or n==5      
          PartDescription.build_default_wear_rates_from_csv(row) if !row[0].nil?     
    end    
  end

  def vin_import(file)
    infile = file.read
    n, errs = 0, []
    CSV.parse(infile) do |row|
      n += 1      
      next if n==1 or row.join.blank?     
        vinimport = VinImport.build_from_csv(row)    
    if vinimport.valid? 
      vinimport.save 
    else 
      errs << row
    end
   end

 end
 
 def tyre_import(file)
   @errors = []
    Vehicle.transaction do
      rows = CSV.parse(file.read)
      rows.each_with_index do |row, index|
        #next if index == 0 #Skip header
        
        part_number, manufacturer, description, tyre_type, vehicle_type, width, profile, construction, diameter, speed_rating, season, ef_rating, wet_rating, noise_rating, price, file_date, supplier, status = row
        
        season = 'S' if season == "Summer"
        season = 'W' if season == "Winter"
        status = 'C' if status == "Current"
        status = 'D' if status == "Discontinued"
        status = 'R' if status == "Discontinued - product in Rundown" 
        
        t = Tyre.new(:part_number => part_number, :manufacturer => manufacturer, :description => description, :tyre_type => tyre_type, :vehicle_type => vehicle_type, :width => width, :profile => profile, :construction => construction, :diameter => diameter, :speed_rating => speed_rating, :season => season, :ef_rating => ef_rating, :wet_rating => wet_rating, :noise_rating => noise_rating, :price => price, :file_date => file_date, :supplier => supplier, :status => status)
        
        begin
          t.save!
        rescue => exc
            #Rails.logger.info t.part_number
            @errors << {:part_number => t.part_number, :errors => t.errors}
        end
      end
      raise ActiveRecord::Rollback unless @errors.empty? #Rollback record
    end
  end
  
  def smr_dataset(file)
    infile = file.read
    n, errs = 0, []
    CSV.parse(infile) do |row|
      n += 1
      if n==1
          @wear_part_index = row.index("Wearing Parts")
          @service_part_index = row.index("Service Parts")
          @services_index = row.index("Services")
          
      end
      if n==2
          @descriptions = PartDescription.build_from_csv(row, @wear_part_index.to_i, @services_index.to_i) # Building Part Description        
      end
      next if n == 3 or n==4
      if row[@services_index.to_i] !="NO DATA"
      @last_index = row.length()
         manufacturer = Manufacturer.build_from_csv_new_car(row) # Building Manufacturer Dataset
        if !manufacturer.blank?       
        model = MakeModel.build_from_csv_new_car(row, manufacturer.id) # Building Model Dataset
        if !model.blank?         
          vehicle = Vehicle.build_from_csv_smr(row, model.id) # Building Vehicle
        if !vehicle.blank?                   
         @total_parts = []
           parts_index_pair =  @descriptions.each_slice(2).to_a # all descriptions into array with their index
           parts_hash_index = parts_index_pair.inject(Hash.new{|h,k| h[k]=[]}) { |h, (k, v)| h[k] << v ; h} # getting indexs of all part into hash 
              parts_hash_index.each do |key, value|
                @total_parts += Part.build_from_csv(row, key, value, manufacturer.id)
              end
              @total_parts.reject!{ |arr| arr.all?(&:blank?) } 
              
              service_plan = ServicePlan.build_from_csv_smr(row, vehicle, @total_parts, @services_index.to_i, @last_index.to_i ) # Building Service Plan
              errs<<row if service_plan.any?
            
        else
          errs<<row
        end
        
        else
          errs<<row
        end
       else
          errs<<row
        end
      else
        errs<<row
      end
    end
     if errs.any?
        errFile ="errors_smr_dataset#{Date.today.strftime('%d%b%y')}.csv"
        errs.insert(0, Vehicle.csv_header)
        errCSV = CSV.generate do |csv|
          errs.each {|row| csv << row}
        end
        send_data errCSV, :type => 'text/csv; charset=iso-8859-1; header=present',
         :disposition => "attachment; filename=#{errFile}.csv"
     end
    
 end

  def country_code_dataset(file)
    infile = file.read
    n, errs = 0, []
    CSV.parse(infile) do |row|
      n += 1
      next if n == 1 or row.join.blank?
      country = Country.build_from_csv(row) # Building Country Dataset
      if country.valid?
      country.save
      else
      errs << row
      end
    end
  end

  def make_model_dataset(file)
    infile = file.read
    n, errs = 0, []
    CSV.parse(infile) do |row|
      n += 1
      next if n == 1 or row.join.blank?
      manufacturer = Manufacturer. build_from_csv(row) # Building Manufacturer Dataset
      if manufacturer.valid?
        manufacturer.save
        model = MakeModel.build_from_csv(row, manufacturer.id) # Building Model Dataset
        if model.valid?
        model.save
        else
        errs << row
        end
     else
      errs << row
     end
     
    end
  end

  def new_car_dataset(file)
    infile = file.read
    n, errs = 0, []
    CSV.parse(infile) do |row|
      n += 1
      next if n == 1 or row.join.blank?
      manufacturer = Manufacturer.build_from_csv_new_car(row) # Building Manufacturer Dataset
       if manufacturer.nil?
        errs<<row
      elsif manufacturer.valid?
        manufacturer.save
        model = MakeModel.build_from_csv_new_car(row, manufacturer.id) # Building Model Dataset
        if model.nil?
        errs<<row
        elsif model.valid?
          model.save       
          vehicle = Vehicle.build_from_csv_new_car(row, model.id) # Building Vehicle
        if vehicle.nil?
          errs<<row
        elsif vehicle.valid?
           vehicle.save
        end
        end
       end
       end
      if errs.any?
        errFile ="errors_new_car_dataset#{Date.today.strftime('%d%b%y')}.csv"
        errs.insert(0, Vehicle.csv_header)
        errCSV = CSV.generate do |csv|
          errs.each {|row| csv << row}
        end
        send_data errCSV,
          :type => 'text/csv; charset=iso-8859-1; header=present',
          :disposition => "attachment; filename=#{errFile}.csv"
      else
        flash[:notice] = I18n.t('File Uploaded without any errors')
      end
end

end


