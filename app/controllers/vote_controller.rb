class VoteController < ApplicationController
  def new
  	@decisionroom = Decisionroom.find(params[:decisionroom_id])
  end
end
