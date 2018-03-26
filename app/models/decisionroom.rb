class Decisionroom < ApplicationRecord
	has_many :user_decisionrooms
	has_many :users, :through => :user_decisionrooms
	validates :name, :presence => true, :uniqueness =>true
end