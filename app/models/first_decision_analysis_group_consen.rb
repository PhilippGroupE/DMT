class FirstDecisionAnalysisGroupConsen < ApplicationRecord
	belongs_to :decisionroom

	def self.create(decisionroom, group_consens)
		gc = FirstDecisionAnalysisGroupConsen.new
		gc.decisionroom_id = decisionroom
		gc.group_consens = group_consens
		# this is a placehoder: here should be an analysis which compares,
		# the group_consens of the focal group to others
		self.determine_ranks
		gc.rank = 0
		gc.save
	end

	def self.determine_ranks
		counter = 1
		FirstDecisionAnalysisGroupConsen.order(:group_consens).each do |consens|
			consens.rank = counter
			counter += 1
		end
	end
end
