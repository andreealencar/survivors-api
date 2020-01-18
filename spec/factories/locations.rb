FactoryBot.define do
  factory :location do
    lat { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    lng { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
  end
end
