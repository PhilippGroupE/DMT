class DecisionmakerController < ApplicationController

  def index
  	@decisionroom = Decisionroom.find(params[:decisionroom_id])
    @decisionmaker = @decisionroom.users.all
  end

  def new
  	@decisionroom = Decisionroom.find(params[:decisionroom_id])
    @decisionmaker = @decisionroom.users.build
  end

  def create
  	@decisionroom = Decisionroom.find(params[:decisionroom_id])
    @decisionmaker = User.find_by_email(params[:email])
    if @decisionmaker.nil?
      redirect_to new_decisionroom_decisionmaker_path(@decisionroom), notice: "Decision Maker does not exist. Please choose another one!"
    else
      begin
        @decisionroom.users << @decisionmaker
      rescue ActiveRecord::RecordNotUnique
      end
      redirect_to decisionroom_path(@decisionroom), notice: "User added!"
    end
  end

end
