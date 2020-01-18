FactoryBot.define do
  factory :item do
    name   { Faker::Name.unique.name }
    points { Faker::Number.between(from: 1, to: 10) }
  end
end
