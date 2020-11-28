FactoryBot.define do
  # ユーザーファクトリにエイリアス名で参照され得ると伝える
  factory :user, aliases: %i[follower followed] do
    name  { "testUser" }
    sequence(:email) { |n| "example#{n}@example.com" }
    password { "password" }
  end
end
