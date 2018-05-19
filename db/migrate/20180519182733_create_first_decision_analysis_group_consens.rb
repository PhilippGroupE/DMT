class CreateFirstDecisionAnalysisGroupConsens < ActiveRecord::Migration[5.1]
  def change
    create_table :first_decision_analysis_group_consens do |t|
      t.belongs_to :decisionroom
      t.float :group_consens
      t.float :rank

      t.timestamps
    end
  end
end
