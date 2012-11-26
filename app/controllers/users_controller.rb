class UsersController < ApplicationController

load_and_authorize_resource

  def index
      @users = User.all
    end

  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end


  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save

        @users = User.find(:all, :order => "created_at DESC")
        format.html { render action: "show" }
        format.json { render json: @user, status: :created, location: @user }

      else
        format.html {  render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  @users = User.find(:all, :order => "updated_at DESC")
  
   respond_to do |format|
     format.html # show.html.erb
     format.json  { render json: @user }
   end
 end


  def edit
    @user = User.find(params[:id])
  end


  def update
    @user = User.find(params[:id])

    respond_to do |format|
       if @user.update_attributes(params[:user])
          format.html { redirect_to @user, notice: 'User was successfully updated'}
          format.json { head :ok }
       else
          format.html { render action: "edit" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
       end
    end
  end

  def for_company
    @users = Company.find(params[:company_id]).users
    render action: "index"
  end



end
