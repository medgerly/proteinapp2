class CreateMealTemplates < ActiveRecord::Migration[8.0]
  def change
    create_table :meal_templates do |t|
      t.references :user, null: false, foreign_key: true
      t.string :meal_name, null: false
      t.float :protein, null: false, default: 0.0
      t.float :carbs, default: 0.0
      t.float :fat, default: 0.0
      t.float :calories, default: 0.0
      t.integer :times_used, default: 0

      t.timestamps
    end

    add_index :meal_templates, [:user_id, :meal_name]
  end
end
