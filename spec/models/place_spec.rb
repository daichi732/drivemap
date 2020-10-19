require 'rails_helper'

RSpec.describe Place, type: :model do
  let(:place) { FactoryBot.build(:place) }

  it "名称、種類、住所がある場合有効であること" do
    place.image = fixture_file_upload("/files/test_image.png")
    expect(place).to be_valid
  end

  it "名称がない場合無効であること" do
    place.name = nil
    place.valid?
    expect(place.errors[:name]).to include("を入力してください")
  end

  it "名称が21文字の場合無効であること" do 
    place.name = "a" * 21
    place.valid?
    expect(place.errors[:name]).to include("は20文字以内で入力してください")
  end

  it "種類がない場合無効であること" do
    place.genre = nil
    place.valid?
    expect(place.errors[:genre]).to include("を入力してください")
  end

  it "住所がない場合無効であること" do
    place.address = nil
    place.valid?
    expect(place.errors[:address]).to include("を入力してください")
  end

  it "画像がない場合無効であること" do
    place.valid?
    expect(place.errors[:image]).to include("ファイルを添付してください")
  end

  it "画像がjpeg/gif/pngでない場合無効であること" do
    place.image = fixture_file_upload("/files/invalid_file.txt")
    place.valid?
    expect(place.errors[:image]).to include("にはjpegまたはgifまたはpngファイルを添付してください")
  end

  it "該当するPlaceモデルインスタンスはuserがいいねがしているか確認すること" do
    user = FactoryBot.create(:user)

    place.image = fixture_file_upload("/files/test_image.png")
    place.save

    expect(place.liked_by?(user)).to be_falsey

    like = FactoryBot.create(:like, user_id: user.id, place_id: place.id)

    expect(place.liked_by?(user)).to be_truthy
  end
end