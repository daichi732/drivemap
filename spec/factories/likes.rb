FactoryBot.define do
  factory :like do
    association :user
    association :place
  end
end
