class CreateDecisionrooms < ActiveRecord::Migration[5.1]
  def change
    create_table :decisionrooms do |t|
      t.string :name
      t.timestamps
    end
  end
end
