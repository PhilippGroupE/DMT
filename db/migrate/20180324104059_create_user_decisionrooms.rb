class CreateUserDecisionrooms < ActiveRecord::Migration[5.1]
  def change
    create_table :user_decisionrooms do |t|
      t.belongs_to :user, index: true
      t.belongs_to :decisionroom, index:true
      t.timestamps
    end
  end
end
