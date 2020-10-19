require 'rails_helper'

RSpec.describe Place, type: :model do
  describe "バリデーションのテスト" do
    let(:place) { FactoryBot.build(:place) }

    context "nameカラム" do
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
    end

    context "genreカラム" do
      it "種類がない場合無効であること" do
        place.genre = nil
        place.valid?
        expect(place.errors[:genre]).to include("を入力してください")
      end
    end

    context "addressカラム" do
      it "住所がない場合無効であること" do
        place.address = nil
        place.valid?
        expect(place.errors[:address]).to include("を入力してください")
      end
    end

    context "image画像" do
      it "画像がない場合無効であること" do
        place.valid?
        expect(place.errors[:image]).to include("ファイルを添付してください")
      end
  
      it "画像がjpeg/gif/pngでない場合無効であること" do
        place.image = fixture_file_upload("/files/invalid_file.txt")
        place.valid?
        expect(place.errors[:image]).to include("にはjpegまたはgifまたはpngファイルを添付してください")
      end
    end

    context "ロジック" do
      it "該当するPlaceモデルインスタンスはuserがいいねがしているか確認すること" do
        user = FactoryBot.create(:user)
  
        place.image = fixture_file_upload("/files/test_image.png")
        place.save
  
        expect(place.liked_by?(user)).to be_falsey
  
        like = FactoryBot.create(:like, user_id: user.id, place_id: place.id)
  
        expect(place.liked_by?(user)).to be_truthy
      end
    end
  end

  describe "アソシエーションのテスト" do
    let(:association) do
      # Placeクラスと引数のクラスの関連を返す
      described_class.reflect_on_association(target)
    end

    context 'Likeモデルとの関係' do
      let(:target) { :likes }

      it '1対多である' do
        expect(association.macro).to eq :has_many
      end
    end

    context 'Commentモデルとの関係' do
      let(:target) { :comments }

      it '1対多である' do
        expect(association.macro).to eq :has_many
      end
    end

    context 'Scheduleモデルとの関係' do
      let(:target) { :schedules }

      it '1対多である' do
        expect(association.macro).to eq :has_many
      end
    end
  end
end