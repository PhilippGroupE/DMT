class Teamoutcome < ApplicationRecord
	belongs_to :decisionroom
	belongs_to :alternative
	belongs_to :criterion

	def self.create_outcome(alternative, criterion, average, decisionroom)
		outcome = Teamoutcome.new
		outcome.alternative_id = alternative.id
		outcome.criterion_id = criterion.id
		outcome.average_value = average
		outcome.decisionroom_id = decisionroom.id
		outcome.save
	end
end
