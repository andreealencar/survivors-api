FactoryBot.define do
  factory :survivor do
    name   { Faker::Name.unique.name }
    age    { Faker::Number.between(from: 0, to: 70) }
    gender { ['male', 'female'].sample }
  end
end
