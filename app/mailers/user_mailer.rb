class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.user_approved.subject
  #
  def user_approved
    @greeting = "Hi"
    @user = params[:user]

    mail(
      from: "support@stockapp.com",
      to: @user.email,
      cc: "secret@stockapp.com", 
      bcc: "zenithmanuel@gmail.com",
      subject: "Your account has been approved"
    ) 
  end
end
