FactoryBot.define do
  factory :schedule do
    association :user
    association :place
    date { "2020-01-01 00:00:00" }
  end
end
