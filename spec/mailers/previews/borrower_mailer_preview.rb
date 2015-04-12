# Preview all emails at http://localhost:3000/rails/mailers/borrower_mailer
class BorrowerMailerPreview < ActionMailer::Preview
  def project_contributed_to
    user = User.create(name: "Bob", email: "bob@example.com", password: "password")
    BorrowerMailer.project_contributed_to(user, "Project Title")
  end
end
