class DecisionroomController < ApplicationController
  before_action :authenticate_user!

  def index
  	@decisionroom = current_user.decisionrooms.order(:id)
  end

  def show
    @decisionroom = current_user.decisionrooms.find(params[:id])
  end

  def new
    @decisionroom = current_user.decisionrooms.build
  end

  def create
    @decisionroom = current_user.decisionrooms.build(decisionroom_params)
    @decisionroom.users << current_user
    if @decisionroom.save
      redirect_to decisionroom_path(@decisionroom), notice: "Decisionroom created!"
    
    else
      @errors = @decisionroom.errors.full_messages
      render:new
    end

  end

  def index_decisionmaker
    decisionroom = Decisionroom.find(params[:decisionroom_id])
    @decisionmaker = decisionroom.users.all
  end




  def new_decisionmaker
    @decisionroom = Decisionroom.find(params[:decisionroom_id])
    @new_decisionmaker = @decisionroom.users.build
  end

  def create_decisionmaker
    @decisionroom = Decisionroom.find(params[:decisionroom_id])
    @new_decisionmaker = User.find_by_email(params[:email])
    @decisionroom.users << @new_decisionmaker
    
    if @decisionroom.save
      redirect_to decisionroom_path(@decisionroom), notice: "User added!"
    
    else
      @errors = @decisionroom.errors.full_messages
      render:new_decisionmaker
    end  
  end

  def update
  end

  def delete
  end

  def decisionroom_params
    params.require(:decisionroom).permit(:name)
  end

end