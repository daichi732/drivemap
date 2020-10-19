FactoryBot.define do
  factory :schedule do
    association :place
    user { place.user }
    date { "2020-01-01 00:00:00" }
  end
end
