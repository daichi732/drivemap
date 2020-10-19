FactoryBot.define do
  factory :like do
    association :place
    user { place.user }
  end
end
