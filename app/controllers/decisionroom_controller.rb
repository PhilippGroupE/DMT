class DecisionroomController < ApplicationController
  before_action :authenticate_user!
  
  def index
  	@decisionroom = current_user.decisionrooms.order(:id)
  end

  def show
    @decisionroom = current_user.decisionrooms.find(params[:id])
    @ary = Array.new
    @test = 1
    @decisionroom.user_decisionrooms.each do |decisionmaker|
      if !decisionmaker.has_voted then
        @test = 0
      end
    end
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
    # Initialize
    @decisionroom = Decisionroom.find(params[:id])
    
    @decisionroom.update_attributes(decisionroom_params)
    # Save Conditions
    if @decisionroom.save
      after_update
      redirect_to decisionroom_path(@decisionroom), notice: "Decisionroom created!"
    else
      @errors = @decisionroom.errors.full_messages
      render:new
    end
  end

  def after_update
     @decisionroom = Decisionroom.find(params[:id])

     # Determining votes_weighted
     @decisionroom.votes.each do |vote|
       @decisionroom.criterions.each do |criterion|
         if criterion.id == vote.criterion_id && current_user.id == vote.user_id then
           vote.weighted_value(criterion.weight)
         end
       end
     end
     # set has voted to true
     @decisionroom.user_decisionrooms.find_by(user_id: current_user.id).update_attributes(has_voted: true)
     

     # Determining weighted_sum 
     @decisionroom.update_attributes(decisionroom_params)
     @decisionroom.alternatives.each do |alternative|
        sum = Vote.where(user_id: current_user.id, alternative_id: alternative.id).sum(:value_weighted)
        WeightedSum.create(alternative.id, current_user.id, sum)
     end
     

  end


  def destroy
    @decisionroom = Decisionroom.find(params[:id])
    @decisionroom.destroy
    redirect_to decisionroom_index_path, notice: "Decisionroom deleted!"
  end

  def decisionroom_params
    params.require(:decisionroom).permit(:name, alternatives_attributes: [:id, :_destroy, :name, :description], criterions_attributes: [:id, :_destroy, :name, :description, :weight], votes_attributes: [:id, :_destroy, :alternative_id, :criterion_id, :user_id, :value, :value_weighted], user_decisionroom_attributes: [:has_voted])
  end

end
