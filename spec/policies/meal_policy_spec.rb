require "rails_helper"
require "support/factory_helpers"

RSpec.describe MealPolicy, type: :policy do
  let(:user) { create_user }
  let(:other_user) { create_user }
  let(:goal) { create_goal(user, goal_date: Date.today) }
  let(:other_goal) { create_goal(other_user, goal_date: Date.today) }
  let(:meal) { create_meal(goal) }
  let(:other_meal) { create_meal(other_goal) }

  describe "#create?" do
    it "grants access when goal belongs to user" do
      new_meal = goal.meals.build(meal_name: "Test", protein: 20)
      expect(described_class.new(user, new_meal).create?).to be true
    end

    it "denies access when goal belongs to other user" do
      new_meal = other_goal.meals.build(meal_name: "Test", protein: 20)
      expect(described_class.new(user, new_meal).create?).to be false
    end
  end

  describe "#update?" do
    it "grants access to meal owner" do
      expect(described_class.new(user, meal).update?).to be true
    end

    it "denies access to non-owner" do
      expect(described_class.new(other_user, meal).update?).to be false
    end
  end

  describe "#destroy?" do
    it "grants access to meal owner" do
      expect(described_class.new(user, meal).destroy?).to be true
    end

    it "denies access to non-owner" do
      expect(described_class.new(other_user, meal).destroy?).to be false
    end
  end
end
