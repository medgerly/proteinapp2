require "rails_helper"
require "support/factory_helpers"

RSpec.describe Goal, type: :model do
  let(:user) { create_user }
  subject(:goal) { create_goal(user) }

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:meals).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:protein_goal) }
    it { is_expected.to validate_presence_of(:goal_date) }

    it "validates protein_goal > 0" do
      goal.protein_goal = 0
      expect(goal).not_to be_valid
    end

    it "validates protein_goal <= 1000" do
      goal.protein_goal = 1001
      expect(goal).not_to be_valid
    end

    it "validates goal_date uniqueness per user" do
      duplicate = user.goals.build(protein_goal: 120, goal_date: goal.goal_date)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:goal_date]).to include("already has a goal set")
    end
  end

  describe "#protein_total" do
    it "returns the sum of meal protein" do
      create_meal(goal, protein: 30.0)
      create_meal(goal, protein: 25.5)
      expect(goal.protein_total).to eq(55.5)
    end

    it "returns 0.0 when no meals" do
      expect(goal.protein_total).to eq(0.0)
    end
  end

  describe "#protein_remaining" do
    it "returns remaining protein needed" do
      goal.protein_goal = 100.0
      create_meal(goal, protein: 60.0)
      expect(goal.protein_remaining).to eq(40.0)
    end

    it "returns 0 when goal is exceeded" do
      goal.protein_goal = 50.0
      create_meal(goal, protein: 80.0)
      expect(goal.protein_remaining).to eq(0.0)
    end
  end

  describe "#protein_progress_pct" do
    it "calculates progress as percentage" do
      goal.protein_goal = 100.0
      create_meal(goal, protein: 75.0)
      expect(goal.protein_progress_pct).to eq(75)
    end

    it "caps at 100" do
      goal.protein_goal = 50.0
      create_meal(goal, protein: 100.0)
      expect(goal.protein_progress_pct).to eq(100)
    end
  end

  describe "#met_goal?" do
    it "returns true when protein_total >= protein_goal" do
      goal.protein_goal = 100.0
      create_meal(goal, protein: 100.0)
      expect(goal.met_goal?).to be true
    end

    it "returns false when protein_total < protein_goal" do
      goal.protein_goal = 100.0
      create_meal(goal, protein: 50.0)
      expect(goal.met_goal?).to be false
    end
  end

  describe "#today?" do
    it "returns true when goal_date is today" do
      goal.goal_date = Date.today
      expect(goal.today?).to be true
    end

    it "returns false when goal_date is not today" do
      goal.goal_date = Date.yesterday
      expect(goal.today?).to be false
    end
  end
end
