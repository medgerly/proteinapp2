# == Schema Information
#
# Table name: meal_templates
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  meal_name  :string           not null
#  protein    :float            not null, default: 0.0
#  carbs      :float            default: 0.0
#  fat        :float            default: 0.0
#  calories   :float            default: 0.0
#  times_used :integer          default: 0
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class MealTemplate < ApplicationRecord
  belongs_to :user

  strip_attributes only: [:meal_name]

  validates :meal_name, presence: true
  validates :protein, numericality: { greater_than_or_equal_to: 0 }

  scope :popular, -> { order(times_used: :desc) }
  scope :search_by_name, ->(q) { where("meal_name ILIKE ?", "%#{q}%") if q.present? }
end
