FactoryBot.define do
  factory :comment do
    association :place
    user { place.user }
    content { "コメントテスト" }
  end
end
