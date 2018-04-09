class CreateWeightedSums < ActiveRecord::Migration[5.1]
  def change
    create_table :weighted_sums do |t|
      t.belongs_to :user, foreign_key: true, on_delete: :cascade
      t.belongs_to :alternative, foreign_key: true, on_delete: :cascade
      t.float :sum

      t.timestamps
    end
  end
end
