require "rails_helper"

RSpec.describe Order, type: :model do

  context "invalid attributes" do
    it "is invalid without any attributes" do
      order = Order.new
      expect(order).to_not be_valid
    end

    it "is invalid without a user_id" do
      order = Order.new(cart_items: "{'9'=>1}")
      expect(order).to_not be_valid
    end

    it "is invalid without cart_items" do
      order = Order.new(user_id: 1)
      expect(order).to_not be_valid
    end
  end
end
