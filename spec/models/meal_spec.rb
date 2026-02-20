require "rails_helper"
require "support/factory_helpers"

RSpec.describe Meal, type: :model do
  let(:user) { create_user }
  let(:goal) { create_goal(user, goal_date: Date.today) }
  subject(:meal) { create_meal(goal) }

  describe "associations" do
    it { is_expected.to belong_to(:goal) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:meal_name) }
    it { is_expected.to validate_presence_of(:protein) }

    it "validates meal_name length" do
      meal.meal_name = "a" * 101
      expect(meal).not_to be_valid
    end

    it "validates protein >= 0" do
      meal.protein = -1
      expect(meal).not_to be_valid
    end

    it "validates protein <= 500" do
      meal.protein = 501
      expect(meal).not_to be_valid
    end

    it "validates calories >= 0" do
      meal.calories = -1
      expect(meal).not_to be_valid
    end
  end

  describe "#set_logged_on" do
    it "defaults logged_on to goal_date" do
      new_meal = goal.meals.create!(meal_name: "Test", protein: 20.0)
      expect(new_meal.logged_on).to eq(goal.goal_date)
    end
  end
end
