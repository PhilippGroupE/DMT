class WeightedSum < ApplicationRecord
	belongs_to :user
	belongs_to :alternative

	def self.calculate_sum(alternative_id, alternative_user)
		ws = WeightedSum.new
		ws.alternative_id = alternative_id
		ws.user_id = alternative_user
		summe = Vote.where(alternative_id: alternative_id, user_id: alternative_user).sum(:value_weighted)
		ws.sum = summe
		ws.save
	end
end
