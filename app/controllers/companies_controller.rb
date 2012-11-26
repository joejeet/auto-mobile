class CompaniesController < ApplicationController

load_and_authorize_resource

def index
  @companies = Company.all
end

def new
  @company = Company.new

  respond_to do |format|
    format.html # new.html.erb
    format.json
  end
end


def create
  @company = Company.new(params[:company])

  respond_to do |format|
    if @company.save
      @companies = Company.all
      format.html { render action: "show" }
      format.json { render json: @company, status: :created, location: @company }

    else
      format.html {  render action: "new" }
      format.json { render json: @company.errors, status: :unprocessable_entity }
    end
  end
end

def show
@companies = Company.all

  respond_to do |format|
    format.html # show.html.erb
    format.json  { render json: @company }
  end
end


def edit
  @company = Company.find(params[:id])
end


def update
  @company = Company.find(params[:id])

  respond_to do |format|
     if @company.update_attributes(params[:company])
        format.html { redirect_to @company, notice: 'Company was successfully updated'}
        format.json { head :ok }
     else
        format.html { render action: "edit" }
        format.json { render json: @company.errors, status: :unprocessable_entity }
     end
  end
end



end
