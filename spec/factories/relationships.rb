FactoryBot.define do
  factory :relationship do
    # user.rbでaliasを書くことでuserを記述する必要なし
    association :follower
    association :followed
  end
end
