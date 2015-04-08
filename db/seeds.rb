class Seed
  def run
    create_known_users
    create_borrowers(10)
    create_lenders(10)
    create_loan_requests_for_each_borrower(3)
    create_categories(7)
  end

  def lenders
    User.where(role: 0)
  end

  def borrowers
    User.where(role: 1)
  end

  def create_known_users
    User.create(name: "Jorge", email: "jorge@example.com", password: "password")
    User.create(name: "Rachel", email: "rachel@example.com", password: "password")
    User.create(name: "Josh", email: "josh@example.com", password: "password", role: 1)
  end

  def create_lenders(quantity)
    quantity.times do
      name = Faker::Name.name
      email = Faker::Internet.email
      user = User.create(name: name,
                         password: "password",
                         email: email,
                         role: 0)
      puts "created user #{user.name}"
    end
  end

  def create_borrowers(quantity)
    quantity.times do
      name = Faker::Name.name
      email = Faker::Internet.email
      user = User.create(name: name,
                         password: "password",
                         email: email,
                         role: 1)
      puts "created user #{user.name}"
    end
  end

  def create_categories(quantity)
    quantity.times do
      title = Faker::Lorem.words(2).join(" ")
      description = Faker::Lorem.sentence
      category = Category.create(title: title, description: description)
      puts "created category #{category.title}"
    end
    put_requests_in_categories
  end

  def put_requests_in_categories
    LoanRequest.all.shuffle.each do |request|
      Category.all.shuffle.first.loan_requests << request
      puts "linked request and category"
    end
  end

  def create_loan_requests_for_each_borrower(quantity)
    quantity.times do
      borrowers.each do |borrower|
        title = Faker::Lorem.words(3).join(" ")
        description = Faker::Lorem.sentence
        status = [0, 1].sample
        request_by =
          Faker::Time.between(7.days.ago, 3.days.ago)
        repayment_begin_date =
          Faker::Time.between(3.days.ago, Time.now)
        amount = "200"
        contributed = "150"
        request = borrower.loan_requests.create(title: title,
                                                description: description,
                                                amount: amount,
                                                status: status,
                                                requested_by_date: request_by,
                                                contributed: contributed,
                                                repayment_rate: "weekly",
                                                repayment_begin_date: repayment_begin_date)
        puts "created loan request #{request.title} for #{borrower.name}"
        puts "There are now #{LoanRequest.all.count} requests"
      end
    end
  end
end

Seed.new.run
