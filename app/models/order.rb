class Order < ActiveRecord::Base
  validates :user_id, :cart_items, presence: true
  belongs_to :user
  enum status: %w(ordered paid cancelled completed)

  def created_at_formatted
    created_at.strftime("%A, %d %b %Y %l:%M %p")
  end

  def updated_at_formatted
    updated_at.strftime("%A, %d %b %Y %l:%M %p")
  end

  def cart_item_and_quantity
    loan_requests = Hash.new
    cart_items.select { |loan_id, amount| loan_requests[LoanRequest.find(loan_id)] = amount }
    loan_requests
  end

  def update_contributed(user)
    user_id = user.id
    cart_item_and_quantity.each do |loan_request, contribution|
      associate_user_with_loan_request(user_id, loan_request, contribution)
      loan_request.update_attributes(contributed: loan_request.contributed += contribution.to_i)
    end
  end

  def associate_user_with_loan_request(user_id, loan_request, contribution)
    LoanRequestsContributor.lender_contribution(user_id, loan_request).
      first_or_create.increment!(:contribution, contribution.to_i)
  end
end
