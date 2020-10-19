require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { FactoryBot.build(:comment) }

  it "user_id, place_id, contentがある場合有効であること" do
    # idに値を入れてbuildする
    expect(FactoryBot.build_stubbed(:comment)).to be_valid
  end

  it "user_idがない場合無効であること" do
    comment.user_id = nil
    comment.valid?
    expect(comment.errors[:user_id]).to include("を入力してください")
  end

  it "place_idがない場合無効であること" do
    comment.place_id = nil
    comment.valid?
    expect(comment.errors[:place_id]).to include("を入力してください")
  end

  it "contentがない場合無効であること" do
    comment.content = nil
    comment.valid?
    expect(comment.errors[:content]).to include("を入力してください")
  end

  it "contentが51文字の場合無効であること" do
    comment.content = "a" * 51
    comment.valid?
    expect(comment.errors[:content]).to include("は50文字以内で入力してください")
  end
end
