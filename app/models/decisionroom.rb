class Decisionroom < ApplicationRecord
	has_many :user_decisionrooms
	has_many :tables
	has_many :users, :through => :user_decisionrooms
	belongs_to :creator, :class_name => 'User'
	validates :name, :presence => true, :uniqueness => true
end