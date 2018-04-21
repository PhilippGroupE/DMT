class User < ApplicationRecord
	has_one :decisionroom
	has_many :votes, dependent: :delete_all
	has_many :weighted_sums, dependent: :delete_all
end
