class CreateDecisionrooms < ActiveRecord::Migration[5.1]
  def change
    create_table :decisionrooms do |t|
      t.string :name
      t.string :description
      t.integer :creator_id
      t.boolean :has_outcome
      t.string :token, index: true, unique: true

      t.timestamps
    end
  end
end
