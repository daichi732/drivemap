require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:relationship) { FactoryBot.build(:relationship) }

  it "follower_id, followed_idがある場合有効であること" do
    expect(FactoryBot.build_stubbed(:relationship)).to be_valid
  end

  it "follower_idがない場合無効であること" do
    relationship.follower_id = nil
    relationship.valid?
    expect(relationship.errors[:follower_id]).to include("を入力してください")
  end

  it "followed_idがない場合無効であること" do
    relationship.followed_id = nil
    relationship.valid?
    expect(relationship.errors[:followed_id]).to include("を入力してください")
  end
end
