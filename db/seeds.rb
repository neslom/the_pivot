class Seed
  def run
    create_10_lenders
    create_10_borrowers
  end

  def create_10_lenders
    10.times do
      name = Faker::Name.name
      email = Faker::Internet.email
      User.create(name: name, password: 'password', email: email, role: 0)
    end
  end

  def create_10_borrowers
    10.times do
      name = Faker::Name.name
      email = Faker::Internet.email
      User.create(name: name, password: 'password', email: email, role: 1)
    end
  end
end
