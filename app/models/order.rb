class Order < ActiveRecord::Base
  validates :user_id, :cart_items, presence: true
  belongs_to :user
  enum status: %w(ordered paid cancelled completed)
  validate :not_over_funded

  def not_over_funded
    return if errors.any?
    find_loan_requests.each do |loan_request|
      unless (loan_request.contributed + cart_items[loan_request.id.to_s].to_i) <= loan_request.amount
        errors.add("#{loan_request.title}", "only needs $#{loan_request.amount}. Please subtract $#{(loan_request.funding_remaining).abs} from your donation.")
      end
    end
  end

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

  def find_loan_requests
    cart_item_and_quantity.keys.map do |loan_request|
      LoanRequest.find(loan_request.id)
    end
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

  def find_borrower
    cart_item_and_quantity.keys.map do |loan_request|
      User.find(loan_request.user_id)
    end
  end

  def send_contributed_to_email
    cart_item_and_quantity.each do |loan_request, _|
      user = User.find(loan_request.user_id)
      BorrowerMailer.project_contributed_to(user, loan_request.title).deliver_now
    end
  end
end
