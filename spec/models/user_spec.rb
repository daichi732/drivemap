require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーションのテスト" do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }

    context "nameカラム" do
      it "名前、メールアドレス、パスワードがある場合有効であること" do
        expect(FactoryBot.build(:user)).to be_valid
      end
      # to_not, validatesのコメントアウト
      it "名前がない場合無効であること" do 
        user.name = nil
        user.valid?
        expect(user.errors[:name]).to include("を入力してください")
      end

      it "名前が21文字の場合無効であること" do
        user.name = "a" * 21
        user.valid?
        expect(user.errors[:name]).to include("は20文字以内で入力してください")
      end
    end

    context "emailカラム" do
      it "メールアドレスがない場合無効であること" do
        user.email = nil
        user.valid?
        expect(user.errors[:email]).to include("を入力してください")
      end
  
      it "重複したメールアドレスなら無効な状態であること" do
        # シーケンスのおかげ
        other_user.email = user.email
        other_user.valid?
        expect(other_user.errors[:email]).to include("はすでに存在します")
      end
  
      it "メールアドレスは小文字で保存されること" do
        email = "ExamPle@Example.coM"
        user.email = email
        user.save
        expect(user.email).to eq email.downcase
      end
    end

    context "passwordカラム" do
      it "パスワードがない場合無効であること" do
        user.password = nil
        user.valid?
        expect(user.errors[:password]).to include("を入力してください")
      end
    end

    context "avatar画像" do
      it "プロフィール画像が登録できること" do
        user.avatar = fixture_file_upload("/files/test_image.png")
        expect(user).to be_valid
      end
  
      it "プロフィール画像がjpeg/gif/pngでない場合無効であること" do
        user.avatar = fixture_file_upload("/files/invalid_file.txt")
        user.valid?
        expect(user.errors[:avatar]).to include("にはjpegまたはgifまたはpngファイルを添付してください")
      end
    end

    context "ロジック" do
      context "フォロー機能" do
        it "フォローとアンフォローが正常に動作すること" do
          expect(user.following?(other_user)).to be_falsey
          user.follow(other_user)
          expect(user.following?(other_user)).to be_truthy
          user.unfollow(other_user)
          expect(user.following?(other_user)).to be_falsey
        end
      end
  
      context "own?(object)メソッド" do
        it "Userモデルインスタンスが自分のplaceであるか確認すること" do
          # 本来 user = FactoryBot.create(:user)アソシエーションあるからいらない！！
          
          # user = FactoryBot.create(:user)
          # other_user = FactoryBot.create(:user)
    
          # アソシエーションでuserインスタンスも作成されることからcreateにしたいけどimageで引っかかってしまうから
          user_place = FactoryBot.build(:place, user_id: user.id)
          user_place.image = fixture_file_upload("/files/test_image.png")
          user_place.save
    
          other_user_place = FactoryBot.build(:place, user_id: other_user.id)
          other_user_place.image = fixture_file_upload("/files/test_image.png")
          other_user_place.save
    
          expect(user.own?(user_place)).to be_truthy
          expect(user.own?(other_user_place)).to be_falsey
        end
    
        it "Userモデルインスタンスが自分のcommentであるか確認すること" do
          # user = FactoryBot.create(:user)
          # other_user = FactoryBot.create(:user)
    
          common_place = FactoryBot.build(:place)
          common_place.image = fixture_file_upload("/files/test_image.png")
          common_place.save
    
          user_comment = FactoryBot.create(:comment, user_id: user.id, place_id: common_place.id)
    
          other_user_comment = FactoryBot.create(:comment, user_id: other_user.id, place_id: common_place.id)
    
          expect(user.own?(user_comment)).to be_truthy
          expect(user.own?(other_user_comment)).to be_falsey
        end
    
        it "Userモデルインスタンスが自分のscheduleであるか確認すること" do
          user = FactoryBot.create(:user)
          other_user = FactoryBot.create(:user)
    
          common_place = FactoryBot.build(:place)
          common_place.image = fixture_file_upload("/files/test_image.png")
          common_place.save
    
          user_schedule = FactoryBot.create(:schedule, user_id: user.id, place_id: common_place.id)
    
          other_user_schedule = FactoryBot.create(:schedule, user_id: other_user.id, place_id: common_place.id)
    
          expect(user.own?(user_schedule)).to be_truthy
          expect(user.own?(other_user_schedule)).to be_falsey
        end
      end
    end
  end
end
