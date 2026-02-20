# == Schema Information
#
# Table name: goals
#
#  id           :bigint           not null, primary key
#  user_id      :bigint           not null
#  protein_goal :float            not null
#  goal_date    :date             not null
#  notes        :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Goal < ApplicationRecord
  belongs_to :user
  has_many :meals, dependent: :destroy

  strip_attributes only: [:notes]

  validates :protein_goal, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 1000 }
  validates :goal_date, presence: true
  validates :goal_date, uniqueness: { scope: :user_id, message: "already has a goal set" }

  scope :recent, -> { order(goal_date: :desc) }
  scope :for_date, ->(date) { where(goal_date: date) }

  def protein_total
    meals.sum(:protein).round(1)
  end

  def carbs_total
    meals.sum(:carbs).round(1)
  end

  def fat_total
    meals.sum(:fat).round(1)
  end

  def calories_total
    meals.sum(:calories).round(0)
  end

  def protein_remaining
    [protein_goal - protein_total, 0].max.round(1)
  end

  def protein_progress_pct
    return 0 if protein_goal.zero?
    [(protein_total / protein_goal * 100).round, 100].min
  end

  def met_goal?
    protein_total >= protein_goal
  end

  def today?
    goal_date == Date.today
  end
end
