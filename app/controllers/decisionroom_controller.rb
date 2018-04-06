class DecisionroomController < ApplicationController
  before_action :authenticate_user!

  def index
  	@decisionroom = current_user.decisionrooms.order(:id)
  end

  def show
    @decisionroom = current_user.decisionrooms.find(params[:id])
    @ary = Array.new
  end

  def new
    @decisionroom = current_user.decisionrooms.build
  end

  def new_votes
    @decisionroom = Decisionroom.find(params[:decisionroom_id])
    @ary = Array.new
  end

  def create
    @decisionroom = current_user.decisionrooms.build(decisionroom_params)
    @decisionroom.users << current_user
    @decisionroom.creator = current_user
    if @decisionroom.save
      redirect_to decisionroom_new_votes_path(@decisionroom), notice: "Decisionroom created - Please insert your votes!"
    
    else
      @errors = @decisionroom.errors.full_messages
      render:new
    end

  end

  def edit
    @decisionroom = Decisionroom.find(params[:decisionroom_id])
  end

  def update
    @decisionroom = Decisionroom.find(params[:id])
    @decisionroom.update_attributes(decisionroom_params)
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

  def destroy
    @decisionroom = Decisionroom.find(params[:id])
    @decisionroom.destroy
    redirect_to decisionroom_index_path, notice: "Decisionroom deleted!"
  end

  def decisionroom_params
    params.require(:decisionroom).permit(:name, alternatives_attributes: [:id, :_destroy, :name, :description], criterions_attributes: [:id, :_destroy, :name, :description, :weight], votes_attributes: [:id, :_destroy, :alternative_id, :criterion_id, :user_id, :value])
  end

end
