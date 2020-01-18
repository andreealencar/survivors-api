FactoryBot.define do
  factory :inventory_item do
    quantity { Faker::Number.between(from: 1, to: 10) }
    survivor { create(:survivor) }
    item     { create(:item) }
  end
end
