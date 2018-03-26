class CreateTables < ActiveRecord::Migration[5.1]
  def change
    create_table :tables do |t|
    	t.belongs_to :user, index: true
    	t.belongs_to :decisionroom, index:true
      	t.timestamps
    end
    add_index :tables, [:user_id, :decisionroom_id], unique: true
  end
end
