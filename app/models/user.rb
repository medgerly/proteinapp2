# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  first_name             :string           not null
#  last_name              :string           not null
#  email                  :string           not null
#  encrypted_password     :string           not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :goals, dependent: :destroy
  has_many :meals, through: :goals
  has_many :meal_templates, dependent: :destroy

  strip_attributes only: [:first_name, :last_name]

  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def today_goal
    goals.find_by(goal_date: Date.today)
  end

  def today_protein_total
    return 0.0 unless today_goal
    today_goal.meals.sum(:protein)
  end

  def today_protein_goal
    today_goal&.protein_goal || 0.0
  end

  def today_progress_pct
    return 0 if today_protein_goal.zero?
    [(today_protein_total / today_protein_goal * 100).round, 100].min
  end

  def weekly_protein_data
    (6.downto(0)).map do |i|
      date = i.days.ago.to_date
      goal = goals.find_by(goal_date: date)
      {
        date: date.strftime("%a %-m/%-d"),
        total: goal&.meals&.sum(:protein).to_f.round(1),
        target: goal&.protein_goal.to_f
      }
    end.reverse
  end
end
