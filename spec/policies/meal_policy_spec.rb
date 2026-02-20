require "rails_helper"
require "support/factory_helpers"

RSpec.describe MealPolicy, type: :policy do
  let(:user) { create_user }
  let(:other_user) { create_user }
  let(:goal) { create_goal(user, goal_date: Date.today) }
  let(:other_goal) { create_goal(other_user, goal_date: Date.today) }
  let(:meal) { create_meal(goal) }
  let(:other_meal) { create_meal(other_goal) }

  subject { described_class }

  permissions :create? do
    it "grants access when goal belongs to user" do
      new_meal = goal.meals.build(meal_name: "Test", protein: 20)
      expect(subject).to permit(user, new_meal)
    end

    it "denies access when goal belongs to other user" do
      new_meal = other_goal.meals.build(meal_name: "Test", protein: 20)
      expect(subject).not_to permit(user, new_meal)
    end
  end

  permissions :update? do
    it "grants access to meal owner" do
      expect(subject).to permit(user, meal)
    end

    it "denies access to non-owner" do
      expect(subject).not_to permit(other_user, meal)
    end
  end

  permissions :destroy? do
    it "grants access to meal owner" do
      expect(subject).to permit(user, meal)
    end

    it "denies access to non-owner" do
      expect(subject).not_to permit(other_user, meal)
    end
  end
end
