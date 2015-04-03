require "rails_helper"

RSpec.describe Cart, type: :model do

  context "with valid attributes" do
    it "an item is added to the cart" do
      item = create(:item)
      cart = Cart.new(nil)
      cart.add_item(item)
      expect(cart.cart_items.count).to eq(1)
      item2 = Item.create
      cart.add_item(item2)
      expect(cart.cart_items.count).to eq(2)
    end
  end
end
