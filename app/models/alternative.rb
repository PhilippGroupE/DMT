class Alternative < ApplicationRecord
  belongs_to :decisionroom

  has_many :weighted_sums
end
