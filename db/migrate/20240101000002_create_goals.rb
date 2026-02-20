class CreateGoals < ActiveRecord::Migration[8.0]
  def change
    create_table :goals do |t|
      t.references :user, null: false, foreign_key: true
      t.float :protein_goal, null: false
      t.date :goal_date, null: false
      t.text :notes

      t.timestamps
    end

    add_index :goals, [:user_id, :goal_date]
  end
end
