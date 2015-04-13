require "rails_helper"

RSpec.describe Cart, type: :model do
  let!(:user) { User.create(email: "example@example.com", password: "password", name: "example") }

  let!(:loan_request) { LoanRequest.create(title: "Farm Tools",
                                           description: "help out with the farm tools",
                                           amount: "100",
                                           requested_by_date: "2015-06-01",
                                           repayment_begin_date: "2015-12-01",
                                           contributed: "50",
                                           repayment_rate: "monthly",
                                           user_id: user.id)
  }

  let!(:loan_request2) { LoanRequest.create(title: "Farm Stuff",
                                            description: "help out with the farm tools",
                                            amount: "600",
                                            requested_by_date: "2015-09-21",
                                            repayment_begin_date: "2016-10-01",
                                            contributed: "25",
                                            repayment_rate: "monthly",
                                            user_id: user.id)
    }

  let(:cart) { Cart.new(nil) }

  it "is a hash by default" do
    expect(cart.cart_items.class).to eq(Hash)
  end

  it "can have loan requests added" do
    3.times { cart.add_item(loan_request.id, loan_request.amount) }
    2.times { cart.add_item(loan_request2.id, loan_request2.amount) }
    expect(cart.cart_items).to eq({ loan_request.id => 300, loan_request2.id => 1200 })
  end

  it "can delete a loan request" do
    cart.add_item(loan_request.id, loan_request.amount)
    expect(cart.cart_items.count).to eq(1)
    cart.delete_loan_request(loan_request.id)
    expect(cart.cart_items).to be_empty
  end
end
