require "rails_helper"
require "support/factory_helpers"

RSpec.describe GoalPolicy, type: :policy do
  let(:user) { create_user }
  let(:other_user) { create_user }
  let(:goal) { create_goal(user, goal_date: Date.today) }
  let(:other_goal) { create_goal(other_user, goal_date: Date.today) }

  subject { described_class }

  permissions :show? do
    it "grants access to owner" do
      expect(subject).to permit(user, goal)
    end

    it "denies access to other users" do
      expect(subject).not_to permit(other_user, goal)
    end
  end

  permissions :create? do
    it "grants access to any authenticated user" do
      expect(subject).to permit(user, Goal.new)
    end
  end

  permissions :update? do
    it "grants access to owner" do
      expect(subject).to permit(user, goal)
    end

    it "denies access to other users" do
      expect(subject).not_to permit(other_user, goal)
    end
  end

  permissions :destroy? do
    it "grants access to owner" do
      expect(subject).to permit(user, goal)
    end

    it "denies access to other users" do
      expect(subject).not_to permit(other_user, goal)
    end
  end
end
