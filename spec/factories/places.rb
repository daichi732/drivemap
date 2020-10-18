FactoryBot.define do
  factory :place do
    name  { "testPlace" }
    # description { "魅力的な場所です。" }
    genre { 1 }
    address { "東京タワー" }
    # latitude { 35.6585805 }
    # longitude { 139.7454329 }
    association :user
  end
end
