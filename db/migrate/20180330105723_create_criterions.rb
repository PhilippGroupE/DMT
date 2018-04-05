class CreateCriterions < ActiveRecord::Migration[5.1]
  def change
    create_table :criterions do |t|
      t.references :decisionroom, foreign_key: true, on_delete: :cascade
      t.string :name
      t.string :description
      t.float :weight

      t.timestamps
    end
  end
end
