require 'rails_helper'

RSpec.describe Like, type: :model do
  it "user_id, place_idがある場合有効であること" do
    # idに値を入れてbuildする
    expect(FactoryBot.build_stubbed(:like)).to be_valid
  end

  it "user_idがない場合無効であること" do
    like = FactoryBot.build(:like, user_id: nil)
    like.valid?
    expect(like.errors[:user_id]).to include("を入力してください")
  end

  it "place_idがない場合無効であること" do
    like = FactoryBot.build(:like, place_id: nil)
    like.valid?
    expect(like.errors[:place_id]).to include("を入力してください")
  end
end