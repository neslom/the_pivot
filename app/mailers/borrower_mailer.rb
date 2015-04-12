class BorrowerMailer < ApplicationMailer
  default from: "notifications@keevahh.com"

  def project_contributed_to(user)
    @user = user
    @url = "http://protected-lowlands-2991.herokuapp.com"
    mail(to: @user.email, subject: "Your project has been contributed to!")
  end
end
