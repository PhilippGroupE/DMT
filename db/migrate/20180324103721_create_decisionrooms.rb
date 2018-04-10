class CreateDecisionrooms < ActiveRecord::Migration[5.1]
  def change
    create_table :decisionrooms do |t|
      t.string :name
      t.integer :creator_id
      t.boolean :has_outcome
      
      t.timestamps
    end
  end
end
