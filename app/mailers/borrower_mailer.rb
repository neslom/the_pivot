class BorrowerMailer < ApplicationMailer
  default from: "notifications@keevahh.com"

  def project_contributed_to(loan_request)
    @user = loan_request.user
    @project = loan_request.title
    @url = "http://protected-lowlands-2991.herokuapp.com"
    mail(to: @user.email, subject: "Your project has been contributed to!")
  end
end
