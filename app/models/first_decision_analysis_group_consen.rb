class FirstDecisionAnalysisGroupConsen < ApplicationRecord
	belongs_to :decisionroom

	def self.create(decisionroom, group_consens)
		gc = FirstDecisionAnalysisGroupConsen.new
		gc.decisionroom_id = decisionroom
		gc.group_consens = group_consens
		# this is a placehoder: here should be an analysis which compares,
		# the group_consens of the focal group to others
		gc.rank = 0
		gc.save
	end
end
