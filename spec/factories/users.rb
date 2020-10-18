FactoryBot.define do
  factory :user do
    name  { "testUser" }
    sequence(:email) { |n| "example#{n}@example.com" }
    password { "foobar" }
  end
end
