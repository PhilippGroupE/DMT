class TeamoutcomeController < ApplicationController
	before_action :authenticate_user!


	def create
		decisionroom = Decisionroom.find(params[:decisionroom_id])

		decisionroom.alternatives.each do |alternative|
			decisionroom.criterions.each do |criterion|
				average = Vote.where(alternative_id: alternative.id, criterion_id: criterion.id).average(:value_weighted)
				Teamoutcome.create_outcome(alternative, criterion, average, decisionroom)
			end
		end
		after_create
		if decisionroom.save then
			redirect_to decisionroom_teamoutcome_index_path(decisionroom_id: decisionroom.id)
		else
		end
	end

	def after_create
		decisionroom = Decisionroom.find(params[:decisionroom_id])

		decisionroom.alternatives.each do |alternative|
			sum = Teamoutcome.where(alternative_id: alternative.id, decisionroom_id: decisionroom.id).sum(:average_value)
			TeamoutcomeSum.create(alternative_id: alternative.id, decisionroom_id: decisionroom.id, outcome_sum: sum)
		end
	end

	def index
		@decisionroom = Decisionroom.find(params[:decisionroom_id])
	end

end
