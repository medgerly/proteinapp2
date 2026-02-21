require "rails_helper"
require "support/factory_helpers"

RSpec.describe User, type: :model do
  subject(:user) { build(:user) rescue create_user }

  describe "associations" do
    it { is_expected.to have_many(:goals).dependent(:destroy) }
    it { is_expected.to have_many(:meals).through(:goals) }
    it { is_expected.to have_many(:meal_templates).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
  end

  describe "#full_name" do
    it "returns first and last name joined" do
      user = create_user(first_name: "Jane", last_name: "Doe")
      expect(user.full_name).to eq("Jane Doe")
    end
  end

  describe "#today_goal" do
    it "returns the goal for today" do
      user = create_user
      goal = create_goal(user, goal_date: Date.today)
      expect(user.today_goal).to eq(goal)
    end

    it "returns nil when no goal exists for today" do
      user = create_user
      expect(user.today_goal).to be_nil
    end
  end

  describe "#today_protein_total" do
    it "returns sum of protein from today's meals" do
      user = create_user
      goal = create_goal(user, goal_date: Date.today)
      create_meal(goal, protein: 30.0)
      create_meal(goal, protein: 25.0)
      expect(user.today_protein_total).to eq(55.0)
    end

    it "returns 0 when no goal exists" do
      user = create_user
      expect(user.today_protein_total).to eq(0.0)
    end
  end

  describe "#today_progress_pct" do
    it "calculates percentage of goal met" do
      user = create_user
      goal = create_goal(user, protein_goal: 100.0, goal_date: Date.today)
      create_meal(goal, protein: 50.0)
      expect(user.today_progress_pct).to eq(50)
    end

    it "caps at 100%" do
      user = create_user
      goal = create_goal(user, protein_goal: 50.0, goal_date: Date.today)
      create_meal(goal, protein: 100.0)
      expect(user.today_progress_pct).to eq(100)
    end
  end

  describe "#weekly_protein_data" do
    it "returns 7 data points" do
      user = create_user
      expect(user.weekly_protein_data.length).to eq(7)
    end

    it "includes date, total, and target keys" do
      user = create_user
      data = user.weekly_protein_data
      expect(data.first.keys).to include(:date, :total, :target)
    end
  end
end
