require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:place) { create(:place, user: user) }
  let(:other_place) { create(:place, user: other_user) }

  describe "バリデーションのテスト" do
    context "nameカラム" do
      it "名前、メールアドレス、パスワードがある場合有効であること" do
        expect(build(:user)).to be_valid
      end

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
        create(:place, user: user)
        expect { user.destroy }.to change { Place.count }.by(-1)
      end
    end

    context 'Likeモデルとの関連' do
      let(:target) { :likes }

      it '1対多である' do
        expect(association.macro).to eq :has_many
      end

      it "userを削除すると、likeも削除される" do
        create(:like, user: user, place: place)
        expect { user.destroy }.to change { Like.count }.by(-1)
      end
    end

    context 'Commentモデルとの関連' do
      let(:target) { :comments }

      it '1対多である' do
        expect(association.macro).to eq :has_many
      end

      it "userを削除すると、commentも削除される" do
        create(:comment, user: user, place: place)
        expect { user.destroy }.to change { Comment.count }.by(-1)
      end
    end

    context 'Scheduleモデルとの関連' do
      let(:target) { :schedules }

      it '1対多である' do
        expect(association.macro).to eq :has_many
      end

      it "userを削除すると、scheduleも削除される" do
        create(:schedule, user: user, place: place)
        expect { user.destroy }.to change { Schedule.count }.by(-1)
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
        expect(user.following?(other_user)).to be false
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
        expect(user.following?(other_user)).to be false
      end
    end
  end

  describe "ロジックのテスト" do
    describe "#following?(other_user)" do
      context "フォローしていない場合" do
        it "falseを返す" do
          expect(user.following?(other_user)).to be false
        end
      end
      context "フォローした場合" do
        it "trueを返す", js: true do
          user.follow(other_user)
          expect(user.following?(other_user)).to be true
        end
      end
      context "フォローを外した場合" do
        it "falseを返す", js: true do
          user.follow(other_user)
          user.unfollow(other_user)
          expect(user.following?(other_user)).to be false
        end
      end
    end

    describe "#own?(object)" do
      context "object == placeの場合" do
        context "userのplaceの場合" do
          it "trueを返す" do
            expect(user.own?(place)).to be true
          end
        end

        context "userのplaceでない場合" do
          it "falseを返す" do
            expect(user.own?(other_place)).to be false
          end
        end
      end

      context "object == commentの場合" do
        context "userのcommentの場合" do
          it "trueを返す" do
            comment = create(:comment, user: user, place: place)
            expect(user.own?(comment)).to be true
          end
        end

        context "userのcommentでない場合" do
          it "falseを返す" do
            comment = create(:comment, user: other_user, place: place)
            expect(user.own?(comment)).to be false
          end
        end
      end

      context "object == scheduleの場合" do
        context "userのscheduleの場合" do
          it "trueを返す" do
            schedule = create(:schedule, user: user, place: place)
            expect(user.own?(schedule)).to be true
          end
        end

        context "userのscheduleでない場合" do
          it "falseを返す" do
            schedule = create(:schedule, user: other_user, place: place)
            expect(user.own?(schedule)).to be false
          end
        end
      end
    end
  end
end
