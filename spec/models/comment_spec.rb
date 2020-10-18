require 'rails_helper'

RSpec.describe Comment, type: :model do
  it "user_id, place_id, contentがある場合有効であること" do
    expect(FactoryBot.build_stubbed(:comment)).to be_valid
  end

  it "user_idがない場合無効であること" do
    comment = FactoryBot.build(:comment, user_id: nil)
    comment.valid?
    expect(comment.errors[:user_id]).to include("を入力してください")
  end

  it "place_idがない場合無効であること" do
    comment = FactoryBot.build(:comment, place_id: nil)
    comment.valid?
    expect(comment.errors[:place_id]).to include("を入力してください")
  end

  it "contentがない場合無効であること" do
    comment = FactoryBot.build(:comment, content: nil)
    comment.valid?
    expect(comment.errors[:content]).to include("を入力してください")
  end
end
