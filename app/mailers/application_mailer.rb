class ApplicationMailer < ActionMailer::Base
  default from: Settings.default_host_mail
  layout "mailer"
end
