class DailyReminderJob < ApplicationJob
  queue_as :default

  # Enqueue via: DailyReminderJob.perform_later
  # Schedule via cron (e.g., at 6 PM): add to config/solid_queue.yml

  def perform
    User.find_each do |user|
      next if user.today_goal&.met_goal?
      ReminderMailer.daily_reminder(user).deliver_later
    end
  end
end
