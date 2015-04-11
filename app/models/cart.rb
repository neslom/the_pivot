class Cart
  attr_accessor :cart_items

  def initialize(cart_items)
    @cart_items = cart_items || Hash.new
  end

  def add_item(loan_request_id, amount)
    @cart_items[loan_request_id] ||= 0
    @cart_items[loan_request_id] += amount.to_i
  end

  def cart_items_and_amount
    loan_request = Hash.new
    cart_items.select { |loan_request_id, amount| loan_request[LoanRequest.find(loan_request_id)] = amount }
    loan_request
  end

  def delete_item(item_id)
    @cart_items.delete(item_id)
  end

  def increase_loan_request_amount(loan_request_id)
    @cart_items[loan_request_id] += 25
  end

  def decrease_item_quantity(item_id)
    if @cart_items[item_id] > 1
      @cart_items[item_id] -= 1
    else
      @cart_items.delete(item_id)
    end
  end
end
