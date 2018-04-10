class CreateUserDecisionrooms < ActiveRecord::Migration[5.1]
  def change
    create_table :user_decisionrooms do |t|
      t.belongs_to :user, index: true
      t.belongs_to :decisionroom, index:true
      t.boolean :has_voted
      t.timestamps
    end
    add_index :user_decisionrooms, [:user_id, :decisionroom_id], unique: true
  end
end
