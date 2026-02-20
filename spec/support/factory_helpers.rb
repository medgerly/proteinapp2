def create_user(attrs = {})
  User.create!({
    first_name: "Test",
    last_name: "User",
    email: "test_#{SecureRandom.hex(4)}@example.com",
    password: "password123",
    password_confirmation: "password123"
  }.merge(attrs))
end

def create_goal(user, attrs = {})
  user.goals.create!({
    protein_goal: 150.0,
    goal_date: Date.today
  }.merge(attrs))
end

def create_meal(goal, attrs = {})
  goal.meals.create!({
    meal_name: "Test Meal",
    protein: 30.0,
    carbs: 40.0,
    fat: 10.0,
    calories: 370.0
  }.merge(attrs))
end
