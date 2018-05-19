class CreateFirstDecisionAnalyses < ActiveRecord::Migration[5.1]
  def change
    create_table :first_decision_analyses do |t|
      t.belongs_to :decisionroom
      t.integer :usera_id
      t.integer :userb_id
	  t.float :consens
      
      t.timestamps
    end
  end
end
