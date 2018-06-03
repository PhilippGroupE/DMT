class FeedbackController < ApplicationController
	def new
		@feedback = Feedback.new	
	end

	def create
		@feedback = Feedback.create(feedback_params)
		if @feedback.save then
			flash[:notice] = 'Thank you for your feedback!'
			redirect_back  fallback_location: root_path
		else
			@errors = @feedback.errors.full_messages
      		render:new
		end
	end

	def feedback_params
		params.require(:feedback).permit(:text)
	end
end
