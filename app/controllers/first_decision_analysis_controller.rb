class FirstDecisionAnalysisController < ApplicationController
  def index
  	@decisionroom = Decisionroom.find_by(token: params[:decisionroom_token])
  end
end
