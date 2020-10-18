FactoryBot.define do
  factory :comment do
    association :user
    association :place
    content { "コメントテスト" }
  end
end
