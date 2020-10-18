require 'rails_helper'

RSpec.describe Place, type: :model do
  it "名称、種類、住所がある場合有効であること" do
    place = FactoryBot.build(:place)
    place.image = fixture_file_upload("/files/test_image.png")
    expect(place).to be_valid
  end

  it "名称がない場合無効であること" do
    place = FactoryBot.build(:place, name: nil)
    place.valid?
    expect(place.errors[:name]).to include("を入力してください")
  end

  it "名称が21文字の場合無効であること" do 
    place = FactoryBot.build(:place, name: "a" * 21)
    place.valid?
    expect(place.errors[:name]).to include("は20文字以内で入力してください")
  end

  it "種類がない場合無効であること" do
    place = FactoryBot.build(:place, genre: nil)
    place.valid?
    expect(place.errors[:genre]).to include("を入力してください")
  end

  it "住所がない場合無効であること" do
    place = FactoryBot.build(:place, address: nil)
    place.valid?
    expect(place.errors[:address]).to include("を入力してください")
  end

  it "画像がない場合無効であること" do
    place = FactoryBot.build(:place)
    place.valid?
    expect(place.errors[:image]).to include("ファイルを添付してください")
  end
end