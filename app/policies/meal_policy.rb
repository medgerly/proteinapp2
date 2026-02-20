class MealPolicy < ApplicationPolicy
  def show?    = owner?
  def create?  = goal_owner?
  def update?  = owner?
  def destroy? = owner?

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:goal).where(goals: { user: user })
    end
  end

  private

  def owner?
    record.goal&.user == user
  end

  def goal_owner?
    record.goal&.user == user
  end
end
