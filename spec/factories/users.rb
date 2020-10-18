FactoryBot.define do
  factory :user, aliases: [:follower, :followed] do
    name  { "testUser" }
    sequence(:email) { |n| "example#{n}@example.com" }
    password { "foobar" }
  end
end
