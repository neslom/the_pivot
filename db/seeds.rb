class Seed
  def call
    generate_lenders
  end

  def generate_lenders
    @amount_of_lenders = 10

    @amount_of_lenders.times do
      user = User.create(name: Faker::Name.name, email: Faker::Internet.email, password: 'password', role: 0)
      puts "User Created: #{user.name}"
    end
  end

  def self.call
    new.call
  end
end

Seed.call
