class WeightedSum < ApplicationRecord
	belongs_to :user
	belongs_to :alternative

	def self.create(alternative, user, sum)
		ws = WeightedSum.new
		ws.alternative_id = alternative
		ws.user_id = user
		ws.value_weighted_sum = sum
		ws.save
	end
end
