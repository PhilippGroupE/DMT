class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.belongs_to :user, foreign_key: true
	    t.references :decisionroom, foreign_key: true, on_delete: :cascade
      t.belongs_to :alternative, foreign_key: true, on_delete: :cascade
      t.belongs_to :criterion, foreign_key:true, on_delete: :cascade
      t.float :value
      t.timestamps
    end
    add_index :votes, [:user_id, :alternative_id, :criterion_id], unique: true
  end
end
