require "rails_helper"

RSpec.describe User, type: :model do

  before(:each) do
    @user = User.create(email: "example@example.com", password: "password", name: "example")
  end

    it "is valid" do
      expect(@user).to be_valid
    end

    it "is invalid without a password" do
      @user.password = nil
      expect(@user).to_not be_valid
    end

    it "is invalid without an email address" do
      @user.email = nil
      expect(@user).to_not be_valid
    end

    it "is invalid without a name" do
      @user.name = nil
      expect(@user).to_not be_valid
    end

    it "is given a role of lender by default" do
      expect(@user.role).to eq("lender")
    end
end
