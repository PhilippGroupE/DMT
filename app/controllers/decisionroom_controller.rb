class DecisionroomController < ApplicationController
  before_action :logged_in?, except: [:new, :create, :new_ranks, :sort, :new_ranks_not_sorted]
  skip_before_action :verify_authenticity_token, only: [:sort]
  include SessionsHelper

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
    before_sort(@decisionroom)
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
        end
      end
      weight = factor * sum.to_f  
      Criterion.where(id: id).update_all(weight: weight)
    end
    head :ok
  end

  def new_ranks_not_sorted
    @decisionroom = Decisionroom.find_by(token: params[:decisionroom_token])

    total_weights = Criterion.where(decisionroom_id: @decisionroom.id).count
    Criterion.where(decisionroom_id: @decisionroom.id).each do |criterion|
      weight = 1 / total_weights.to_f
      Criterion.where(id: criterion.id).update_all(weight: weight)
    end
    redirect_to new_decisionroom_user_path(@decisionroom)
  end


  def new_votes
    @decisionroom = Decisionroom.find_by(token: params[:decisionroom_token])
    @ary = Array.new
  end

  def create
    @decisionroom = Decisionroom.create(decisionroom_params)
    if @decisionroom.save
      if params[:commit] == 'Create Decision' then
        redirect_to decisionroom_new_ranks_not_sorted_path(decisionroom_token: @decisionroom.token) 
      elsif params[:commit] == 'Rank Your Criterions!' then
        redirect_to decisionroom_new_ranks_path(decisionroom_token: :decisionroom_token), notice: "Decisionroom created - Please insert your votes!"
      end
    else
      @errors = @decisionroom.errors.full_messages
      render:new
    end
  end

  def before_sort(decisionroom)
    $i = 1
    decisionroom.criterions.each do |criterion|
      Criterion.where(id: criterion.id).update_all(position: $i)
      $i += 1
    end

    #SMARTER Method
    decisionroom.criterions.each do |criterion|
      factor = 1 / Criterion.where(decisionroom_id: Criterion.find_by(id: criterion.id).decisionroom_id).count.to_f
      sum = 0.0
      Criterion.where(decisionroom_id: Criterion.find_by(id: criterion.id).decisionroom_id).each do |crit|
        if crit.position >= Criterion.find_by(id: criterion.id).position then
          sum += 1 / crit.position.to_f
        end
      end
      weight = factor * sum.to_f
      Criterion.where(id: criterion.id).update_all(weight: weight)
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
