require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "バリデーションのテスト" do
    let(:comment) { build(:comment) }

    it "user_id, place_id, contentがある場合有効であること" do
      # idに値を入れてbuildする
      expect(build_stubbed(:comment)).to be_valid
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

  describe "アソシエーションのテスト" do
    let(:association) do
      # Commentクラスと引数のクラスの関連を返す
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
