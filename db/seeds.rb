class Seed
  def run
    create_borrowers(10)
    create_lenders(10)
    create_loan_requests(3)
    create_categories(7)
  end

  def lenders
    User.where(role: 0)
  end

  def borrowers
    User.where(role: 1)
  end

  def create_lenders(quantity)
    quantity.times do
      name = Faker::Name.name
      email = Faker::Internet.email
      User.create(name: name, password: 'password', email: email, role: 0)
    end
  end

  def create_borrowers(quantity)
    quantity.times do
      name = Faker::Name.name
      email = Faker::Internet.email
      User.create(name: name, password: 'password', email: email, role: 1)
    end
  end

  def create_categories(quantity)
    title = Faker::Lorem.words(2).join(" ")
    description = Faker::Lorem.sentence
    Category.create(title: title, description: description)
    put_requests_in_categories
  end

  def put_requests_in_categories
    LoanRequest.all.shuffle.each do |request|
      Category.all.shuffle.first.loan_requests << request
    end
  end

  def create_loan_requests(quantity)
    quantity.times do
      borrowers.each do |borrower|
        title = Faker::Lorem.words(3).join(" ")
        description = Faker::Lorem.sentence
        status = [0,1].sample
        request_by = Faker::Time.between(7.days.ago, 3.days.ago)
        repayment_begin_date = Faker::Time.between(3.days.ago, Time.now)
        amount = Faker::Number.number(4)
        borrower.loan_requests.create(title: title, 
                                      description: description, 
                                      amount: amount, 
                                      status: status, 
                                      requested_by_date: request_by, 
                                      repayment_begin_date: repayment_begin_date)
      end
    end
  end
