class CreateTeamoutcomes < ActiveRecord::Migration[5.1]
  def change
    create_table :teamoutcomes do |t|
      t.belongs_to :alternative
      t.belongs_to :criterion
      t.belongs_to :decisionroom
      t.float	:average_value

      t.timestamps
    end
  end
end
