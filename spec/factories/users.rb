FactoryBot.define do
  factory :user, aliases: %i[follower followed] do
    name  { "testUser" }
    sequence(:email) { |n| "example#{n}@example.com" }
    password { "password" }
  end
end
