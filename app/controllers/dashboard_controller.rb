class DashboardController < ApplicationController
  def index
    @today_goal = current_user.today_goal
    @weekly_data = current_user.weekly_protein_data
    @recent_meals = current_user.meals.recent.limit(5)
    @streak = calculate_streak
  end

  private

  def calculate_streak
    streak = 0
    date = Date.today
    loop do
      goal = current_user.goals.find_by(goal_date: date)
      break unless goal&.met_goal?
      streak += 1
      date -= 1.day
    end
    streak
  end
end
