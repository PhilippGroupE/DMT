class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.belongs_to :decisionroom
      t.boolean :has_voted
      t.timestamps
    end
    add_index :users, [:name, :email, :decisionroom_id], unique: true
  end
end
