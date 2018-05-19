class Teamoutcome < ApplicationRecord
	belongs_to :decisionroom
	belongs_to :alternative
	belongs_to :criterion

	has_many :first_decision_analyses, inverse_of: :decisionroom
	
	accepts_nested_attributes_for :first_decision_analyses, allow_destroy: true, reject_if: :all_blank

	def self.create_outcome(alternative, criterion, average, decisionroom)
		outcome = Teamoutcome.new
		outcome.alternative_id = alternative.id
		outcome.criterion_id = criterion.id
		outcome.average_value = average
		outcome.decisionroom_id = decisionroom.id
		outcome.save
	end
end
