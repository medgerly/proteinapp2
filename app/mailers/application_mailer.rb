class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_FROM", "noreply@proteintracker.com")
  layout "mailer"
end
