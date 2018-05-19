class FirstDecisionAnalysis < ApplicationRecord
	belongs_to :decisionroom

	def self.create(decisionroom, usera, userb, consens)
		fda = FirstDecisionAnalysis.new
		fda.decisionroom_id = decisionroom
		fda.usera_id = usera
		fda.userb_id = userb
		fda.consens = consens
		fda.save
	end
end
