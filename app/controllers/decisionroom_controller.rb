class DecisionroomController < ApplicationController
  before_action :logged_in?, except: [:new, :create, :new_ranks, :sort]
  skip_before_action :verify_authenticity_token, only: [:sort]
  include SessionsHelper

  def index
  	@decisionroom = current_user.decisionrooms
  end

  def show
    @decisionroom = Decisionroom.find_by(token: params[:token])
    @ary = Array.new
    @test = 1
    User.where(decisionroom_id: @decisionroom.id).each do |decisionmaker|
      if !decisionmaker.has_voted then
        @test = 0
      end
    end
  end

  def new
    @decisionroom = Decisionroom.new
  end

  def new_ranks
    @decisionroom = Decisionroom.find_by(token: params[:decisionroom_token])
    @decisionroom.criterions.each_with_index do |criterion, index|
      Criterion.where(id: criterion.id).update_all(position: index + 1)
    end
  end

  def sort
    params[:criterion].each_with_index do |id, index|
      Criterion.where(id: id).update_all(position: index + 1)
    end
    # SMARTER Algorithm
    params[:criterion].each_with_index do |id|
      factor = 1 / Criterion.where(decisionroom_id: Criterion.find_by(id: id).decisionroom_id).count.to_f
      sum = 0.0
      Criterion.where(decisionroom_id: Criterion.find_by(id: id).decisionroom_id).each do |crit|
        if crit.position >= Criterion.find_by(id: id).position then
          sum += 1 / crit.position.to_f
          puts "Criterion: #{Criterion.find_by(id: id).id}"
          puts "Position: #{Criterion.find_by(id: id).position.to_f}"
          puts "Sum: #{sum}"
        end
      end
      puts "Factor: #{factor}"
      weight = factor * sum.to_f  
      puts "Weight: #{weight}"
      Criterion.where(id: id).update_all(weight: weight)
    end
    head :ok
  end

  def new_votes
    @decisionroom = Decisionroom.find_by(token: params[:decisionroom_token])
    @ary = Array.new
  end

  def create
    @decisionroom = Decisionroom.create(decisionroom_params)
    if @decisionroom.save
      redirect_to decisionroom_new_ranks_path(decisionroom_token: @decisionroom.token), notice: "Decisionroom created - Please insert your votes!"
    else
      @errors = @decisionroom.errors.full_messages
      render:new
    end
  end

  def edit
    @decisionroom = Decisionroom.find_by(token: params[:decisionroom_token])
  end

  def update
    # Initialize
    @decisionroom = Decisionroom.find_by(token: params[:token])
    
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
     @decisionroom = Decisionroom.find_by(token: params[:token])

     # Determining votes_weighted
     @decisionroom.votes.each do |vote|
       @decisionroom.criterions.each do |criterion|
         if criterion.id == vote.criterion_id && current_user.id == vote.user_id then
           vote.weighted_value(criterion.weight)
         end
       end
     end
     # set has voted to true
     @decisionroom.users.find_by(id: current_user.id).update_attributes(has_voted: true)
     

     # Determining weighted_sum 
     @decisionroom.update_attributes(decisionroom_params)
     @decisionroom.alternatives.each do |alternative|
        sum = Vote.where(user_id: current_user.id, alternative_id: alternative.id).sum(:value_weighted)
        WeightedSum.create(alternative.id, current_user.id, sum)
     end
     

  end


  def destroy
    @decisionroom = Decisionroom.find_by(token: params[:decisionroom_token])
    @decisionroom.destroy
    redirect_to decisionroom_index_path, notice: "Decisionroom deleted!"
  end

  def decisionroom_params
    params.require(:decisionroom).permit(:token ,:name, :description, alternatives_attributes: [:id, :_destroy, :name, :description], criterions_attributes: [:id, :_destroy, :name, :description, :weight, :position], votes_attributes: [:id, :_destroy, :alternative_id, :criterion_id, :user_id, :value, :value_weighted], user_decisionroom_attributes: [:has_voted])
  end
end
