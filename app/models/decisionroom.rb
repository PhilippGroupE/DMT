class Decisionroom < ApplicationRecord
	has_many :user_decisionrooms
	has_many :tables
	has_many :alternatives, inverse_of: :decisionroom
	has_many :users, :through => :user_decisionrooms
	belongs_to :creator, :class_name => 'User'
	validates :name, :presence => true, :uniqueness => true
	accepts_nested_attributes_for :alternatives, allow_destroy: true, reject_if: :all_blank
end