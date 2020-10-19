require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  describe "バリデーションのテスト" do
    # let(:user) { FactoryBot.create(:user) }
    # let(:other_user) { FactoryBot.create(:user) }
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
  end
  
  
  describe "アソシエーションのテスト" do
    let(:association) do
      # Userクラスと引数のクラスの関連を返す
      described_class.reflect_on_association(target)
    end
    
    context 'Placeモデルとの関連' do
      let(:target) { :places }
      
      it '1対多である' do
        expect(association.macro).to eq :has_many
      end
      
      it "userを削除すると、placeも削除される" do
        place = FactoryBot.build(:place, user_id: user.id)
        place.image = fixture_file_upload("/files/test_image.png")
        place.save
        expect{ user.destroy }.to change{ Place.count }.by(-1)
      end
    end
    
    context 'Likeモデルとの関連' do
      let(:target) { :likes }
      
      it '1対多である' do
        expect(association.macro).to eq :has_many
      end
      
      it "userを削除すると、likeも削除される" do
        place = FactoryBot.build(:place, user_id: user.id)
        place.image = fixture_file_upload("/files/test_image.png")
        place.save
        
        like = FactoryBot.create(:like, user_id: user.id, place_id: place.id)
        expect{ user.destroy }.to change{ Like.count }.by(-1)
      end
    end
    
    context 'Commentモデルとの関連' do
      let(:target) { :comments }
      
      it '1対多である' do
        expect(association.macro).to eq :has_many
      end
      
      it "userを削除すると、commentも削除される" do
        place = FactoryBot.build(:place, user_id: user.id)
        place.image = fixture_file_upload("/files/test_image.png")
        place.save
        
        comment = FactoryBot.create(:comment, user_id: user.id, place_id: place.id)
        expect{ user.destroy }.to change{ Comment.count }.by(-1)
      end
    end
    
    context 'Scheduleモデルとの関連' do
      let(:target) { :schedules }
      
      it '1対多である' do
        expect(association.macro).to eq :has_many
      end
      
      it "userを削除すると、scheduleも削除される" do
        place = FactoryBot.build(:place, user_id: user.id)
        place.image = fixture_file_upload("/files/test_image.png")
        place.save
        
        schedule = FactoryBot.create(:schedule, user_id: user.id, place_id: place.id)
        expect{ user.destroy }.to change{ Schedule.count }.by(-1)
      end
    end
    
    context 'Relationshipモデル(active_relationships)モデルとの関連' do
      let(:target) { :active_relationships }
      
      it '1対多である' do
        expect(association.macro).to eq :has_many
      end
      it '結合モデルのクラスはRelationship' do
        expect(association.class_name).to eq 'Relationship'
      end
      
      it "userを削除すると、relationshipsも削除される" do
        user.follow(other_user)
        expect{ user.destroy }.to change{ Relationship.count }.by(-1)
      end
    end
    
    context 'Relationshipモデル(passive_relationships)モデルとの関連' do
      let(:target) { :passive_relationships }
      
      it '1対多である' do
        expect(association.macro).to eq :has_many
      end
      it '結合モデルのクラスはRelationship' do
        expect(association.class_name).to eq 'Relationship'
      end
    end
    
    context 'フォローしているユーザーとの関連' do
      let(:target) { :following }
      
      it '1対多である' do
        expect(association.macro).to eq :has_many
      end
      it '結合モデルのクラスはUser' do
        expect(association.class_name).to eq 'User'
      end

      it 'フォロワーが削除されると、フォローが解消されること' do
        user.follow(other_user)
        user.destroy
        expect(user.following?(other_user)).to be_falsey
      end
    end
    
    context 'フォロワーとの関連' do
      let(:target) { :followers }
      
      it '1対多である' do
        expect(association.macro).to eq :has_many
      end
      it '結合モデルのクラスはUser' do
        expect(association.class_name).to eq 'User'
      end

      it 'フォローしているユーザーが削除されると、フォローが解消されること' do
        user.follow(other_user)
        other_user.destroy
        expect(user.following?(other_user)).to be_falsey
      end
    end
  end

  describe "ロジックのテスト" do
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
