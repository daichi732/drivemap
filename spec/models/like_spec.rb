require 'rails_helper'

RSpec.describe Like, type: :model do
  describe "バリデーションのテスト" do
    let(:like) { build(:like) }

    it "user_id, place_idがある場合有効であること" do
      # idに値を入れてbuildする
      expect(build_stubbed(:like)).to be_valid
    end

    it "user_idがない場合無効であること" do
      like.user_id = nil
      like.valid?
      expect(like.errors[:user_id]).to include("を入力してください")
    end

    it "place_idがない場合無効であること" do
      like.place_id = nil
      like.valid?
      expect(like.errors[:place_id]).to include("を入力してください")
    end
  end

  describe "アソシエーションのテスト" do
    let(:association) do
      # Likeクラスと引数のクラスの関連を返す
      described_class.reflect_on_association(target)
    end

    context 'Userモデルとの関連' do
      let(:target) { :user }

      it '多対1である' do
        expect(association.macro).to eq :belongs_to
      end
    end

    context 'Placeモデルとの関連' do
      let(:target) { :place }

      it '多対1である' do
        expect(association.macro).to eq :belongs_to
      end
    end
  end
  
end