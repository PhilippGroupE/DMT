class Decisionroom < ApplicationRecord
	validates :name, :presence => true
	validates :token, presence: true
	validates :token, uniqueness: true

	before_validation :generate_token, on: :create
	before_create :set_has_outcome_to_false

	has_many :users
	has_many :tables
	has_many :alternatives, inverse_of: :decisionroom, dependent: :destroy
	has_many :criterions, inverse_of: :decisionroom, dependent: :destroy
	has_many :votes, inverse_of: :decisionroom, dependent: :destroy
	has_one :creator, :class_name => 'User'
	
	accepts_nested_attributes_for :alternatives, allow_destroy: true, reject_if: :all_blank
	accepts_nested_attributes_for :criterions, allow_destroy: true, reject_if: :all_blank
	accepts_nested_attributes_for :votes, allow_destroy: true, reject_if: :all_blank

	def generate_token
		begin
			self.token = SecureRandom.urlsafe_base64(64, false)
		end while self.class.find_by(token: token)
	end

	def to_param
		token
	end
	def set_has_outcome_to_false
		self.has_outcome = false
	end
end