class CreateMeals < ActiveRecord::Migration[8.0]
  def change
    create_table :meals do |t|
      t.references :goal, null: false, foreign_key: true
      t.string :meal_name, null: false
      t.float :protein, null: false, default: 0.0
      t.float :carbs, default: 0.0
      t.float :fat, default: 0.0
      t.float :calories, default: 0.0
      t.string :meal_image
      t.date :logged_on

      t.timestamps
    end

    add_index :meals, :logged_on
  end
end
