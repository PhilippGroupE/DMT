class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :decisionroom

  def weighted_value(weight)
  	self.value_weighted = weight * self.value
  end

end
