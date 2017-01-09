class UserMailer < ApplicationMailer

  def account_activation user
    @user = user
    mail to: user.email, subject: t("email_activation_user_subject")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("email_reset_password_html_header")
  end
end
