class DecisionmakerController < ApplicationController

  def index
  	@decisionroom = Decisionroom.find_by(token: params[:decisionroom_token])
  end

  def new
    @decisionroom = Decisionroom.find_by(token: params[:decisionroom_token])
  end
end
