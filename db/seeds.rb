# Seeds for development data
if Rails.env.development?
  user = User.find_or_create_by!(email: "demo@example.com") do |u|
    u.first_name = "Demo"
    u.last_name = "User"
    u.password = "password123"
    u.password_confirmation = "password123"
  end

  puts "Created demo user: #{user.email}"

  3.times do |i|
    goal = Goal.create!(
      user: user,
      protein_goal: [120, 150, 180][i],
      goal_date: i.days.ago.to_date,
      notes: "Goal #{i + 1} - #{['cutting', 'maintaining', 'bulking'][i]}"
    )

    rand(3..6).times do
      goal.meals.create!(
        meal_name: Faker::Food.dish,
        protein: rand(10.0..50.0).round(1),
        carbs: rand(5.0..80.0).round(1),
        fat: rand(2.0..30.0).round(1),
        calories: rand(100.0..700.0).round(0),
        logged_on: goal.goal_date
      )
    end

    puts "Created goal with #{goal.meals.count} meals"
  end
end
