class ReminderMailer < ApplicationMailer
  def daily_reminder(user)
    @user = user
    @goal = user.today_goal
    @protein_logged = @goal&.protein_total || 0
    @protein_goal = @goal&.protein_goal || 0
    @remaining = @goal&.protein_remaining || @protein_goal

    mail(
      to: @user.email,
      subject: "💪 Don't forget your protein today, #{@user.first_name}!"
    )
  end

  def goal_achieved(user, goal)
    @user = user
    @goal = goal

    mail(
      to: @user.email,
      subject: "🎉 You hit your protein goal for #{@goal.goal_date.strftime('%B %-d')}!"
    )
  end
end
