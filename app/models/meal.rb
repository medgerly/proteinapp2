# == Schema Information
#
# Table name: meals
#
#  id        :bigint           not null, primary key
#  goal_id   :bigint           not null
#  meal_name :string           not null
#  protein   :float            not null, default: 0.0
#  carbs     :float            default: 0.0
#  fat       :float            default: 0.0
#  calories  :float            default: 0.0
#  meal_image :string
#  logged_on :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Meal < ApplicationRecord
  belongs_to :goal

  mount_uploader :meal_image, MealImageUploader

  strip_attributes only: [:meal_name]

  validates :meal_name, presence: true, length: { maximum: 100 }
  validates :protein, presence: true,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 500 }
  validates :carbs,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1000 },
            allow_nil: true
  validates :fat,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 500 },
            allow_nil: true
  validates :calories,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5000 },
            allow_nil: true

  before_save :set_logged_on
  after_save :save_as_template

  scope :recent, -> { order(created_at: :desc) }
  scope :for_date, ->(date) { where(logged_on: date) }

  ransack_alias :name, :meal_name

  private

  def set_logged_on
    self.logged_on ||= goal&.goal_date || Date.today
  end

  def save_as_template
    return unless goal&.user
    template = MealTemplate.find_or_initialize_by(user: goal.user, meal_name: meal_name)
    template.protein = protein
    template.carbs = carbs.to_f
    template.fat = fat.to_f
    template.calories = calories.to_f
    template.times_used = (template.times_used || 0) + (template.new_record? ? 1 : 0)
    template.save
  end
end
