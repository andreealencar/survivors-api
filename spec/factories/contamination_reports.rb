FactoryBot.define do
  factory :contamination_report do
    accuser { create(:survivor) }
    suspect { create(:survivor) }
  end
end
