require "rails_helper"

RSpec.describe User, type: :model do
  let!(:user) { User.create(email: "example@example.com", password: "password", name: "example") }

  it "is valid" do
    expect(user).to be_valid
  end

  it "is invalid without a password" do
    user.password = nil
    expect(user).to_not be_valid
  end

  it "is invalid with a password less than 8 characters" do
    user.password = "123456"
    expect(user).to_not be_valid
  end

  it "is invalid without an email address" do
    user.email = nil
    expect(user).to_not be_valid
  end

  it "is invalid without a period in email address" do
    user.email = "jeff@com"
    expect(user).to_not be_valid
  end

  it "is invalid without an @ in email address" do
    user.email = "jeff.com"
    expect(user).to_not be_valid
  end

  it "is invalid without a name" do
    user.name = nil
    expect(user).to_not be_valid
  end

  it "is given a role of lender by default" do
    expect(user.role).to eq("lender")
  end

  it "cannot be created with a duplicate email address" do
    User.create(name: "Steve", email: "example@example.com", password: "password")
    user = User.new(name: "Steve", email: "example@example.com", password: "password")

    expect { user.save! }.to raise_error(/Email has already been taken/)
  end
end
