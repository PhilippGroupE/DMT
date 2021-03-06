class CreateAlternatives < ActiveRecord::Migration[5.1]
  def change
    create_table :alternatives do |t|
      t.references :decisionroom, foreign_key: true, on_delete: :cascade
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
