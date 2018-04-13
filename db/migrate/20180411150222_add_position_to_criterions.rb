class AddPositionToCriterions < ActiveRecord::Migration[5.1]
  def change
    add_column :criterions, :position, :integer
  end
end
