require "rails_helper"

RSpec.describe BorrowerMailer, type: :mailer do

  let(:user) { User.create(name: "Richard", email: "richard@example.com", password: "password") }

  it "sends an email upon loan request contribution" do
    mail = BorrowerMailer.project_contributed_to(user, "Project Title")
    expect(mail.subject).to eq("Your project has been contributed to!")
    expect(mail.to).to eq([user.email])
    expect(mail.from).to eq(["notifications@keevahh.com"])
    expect(mail.body.encoded).to include(user.name)
    expect(mail.body.encoded).to include("Project Title")
  end
end
