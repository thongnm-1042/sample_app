class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("layouts.application.title_activate")
  end

  def password_reset; end
end
