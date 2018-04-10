class UserDecisionroom < ApplicationRecord
	before_create :set_has_voted_to_false
	
	belongs_to :user
	belongs_to :decisionroom

	def set_has_voted_to_false
		self.has_voted = false
	end
end
