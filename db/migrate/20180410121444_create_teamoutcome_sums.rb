class CreateTeamoutcomeSums < ActiveRecord::Migration[5.1]
  def change
    create_table :teamoutcome_sums do |t|
      t.belongs_to :decisionroom, foreign_key: true, on_delete: :cascade
      t.belongs_to :alternative, foreign_key: true, on_delete: :cascade
      t.float :outcome_sum

      t.timestamps
    end
  end
end
