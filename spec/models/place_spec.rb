require 'rails_helper'

RSpec.describe Place, type: :model do
  let(:place) { FactoryBot.create(:place) }
  describe "バリデーションのテスト" do
    context "nameカラム" do
      it "名称、種類、住所がある場合有効であること" do
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

      it "genreで1を選ぶとviewになること" do
        # factoryでgenre { 1 }を定義 
        expect(place.genre).to eq "view"
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
      it "画像があった場合も有効であること" do
        place.image = fixture_file_upload("/files/test_image.png")
        expect(place).to be_valid
      end
  
      it "画像がjpeg/gif/pngでない場合無効であること" do
        place.image = fixture_file_upload("/files/invalid_file.txt")
        place.valid?
        expect(place.errors[:image]).to include("にはjpegまたはgifまたはpngファイルを添付してください")
      end
    end
  end
  
  describe "アソシエーションのテスト" do
    let(:association) do
      # Placeクラスと引数のクラスの関連を返す
      described_class.reflect_on_association(target)
    end

    context 'Userモデルとの関連' do
      let(:target) { :user }

      it '多対1である' do
        expect(association.macro).to eq :belongs_to
      end
    end

    context 'Likeモデルとの関連' do
      let(:target) { :likes }

      it '1対多である' do
        expect(association.macro).to eq :has_many
      end

      it "placeを削除すると、likeも削除される" do
        like = FactoryBot.create(:like, user_id: place.user.id, place_id: place.id)
        expect{ place.destroy }.to change{ Like.count }.by(-1)
      end
    end

    context 'Commentモデルとの関連' do
      let(:target) { :comments }

      it '1対多である' do
        expect(association.macro).to eq :has_many
      end

      it "placeを削除すると、commentも削除される" do
        comment = FactoryBot.create(:comment, user_id: place.user.id, place_id: place.id)
        expect{ place.destroy }.to change{ Comment.count }.by(-1)
      end
    end

    context 'Scheduleモデルとの関連' do
      let(:target) { :schedules }

      it '1対多である' do
        expect(association.macro).to eq :has_many
      end

      it "placeを削除すると、scheduleも削除される" do
        schedule = FactoryBot.create(:schedule, user_id: place.user.id, place_id: place.id)
        expect{ place.destroy }.to change{ Schedule.count }.by(-1)
      end
    end
  end

  describe "ロジックのテスト" do
    context "liked_by?(user)メソッド" do
      it "userがplaceをいいねしているか確認すること" do
        user = FactoryBot.create(:user)
        
        expect(place.liked_by?(user)).to be_falsey
  
        like = FactoryBot.create(:like, user_id: user.id, place_id: place.id)
  
        expect(place.liked_by?(user)).to be_truthy
      end
    end
  end
end