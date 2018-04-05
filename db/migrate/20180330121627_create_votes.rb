class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :decisionroom, foreign_key: true
      t.timestamps
    end
    add_index :votes, [:user_id, :decisionroom_id], unique: true
  end
end
