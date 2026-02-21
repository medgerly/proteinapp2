require "rails_helper"
require "support/factory_helpers"

RSpec.describe GoalPolicy, type: :policy do
  let(:user) { create_user }
  let(:other_user) { create_user }
  let(:goal) { create_goal(user, goal_date: Date.today) }
  let(:other_goal) { create_goal(other_user, goal_date: Date.today) }

  describe "#show?" do
    it "grants access to owner" do
      expect(described_class.new(user, goal).show?).to be true
    end

    it "denies access to other users" do
      expect(described_class.new(other_user, goal).show?).to be false
    end
  end

  describe "#create?" do
    it "grants access to any authenticated user" do
      expect(described_class.new(user, Goal.new).create?).to be true
    end
  end

  describe "#update?" do
    it "grants access to owner" do
      expect(described_class.new(user, goal).update?).to be true
    end

    it "denies access to other users" do
      expect(described_class.new(other_user, goal).update?).to be false
    end
  end

  describe "#destroy?" do
    it "grants access to owner" do
      expect(described_class.new(user, goal).destroy?).to be true
    end

    it "denies access to other users" do
      expect(described_class.new(other_user, goal).destroy?).to be false
    end
  end
end
