require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe "バリデーションのテスト" do
    let(:relationship) { build(:relationship) }
  
    it "follower_id, followed_idがある場合有効であること" do
      expect(build_stubbed(:relationship)).to be_valid
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

  describe "アソシエーションのテスト" do
    let(:association) do
      # Relationshipクラスと引数のクラスの関連を返す
      described_class.reflect_on_association(target)
    end

    context 'Userモデル(follower)との関連' do
      let(:target) { :follower}

      it '多対1である' do
        expect(association.macro).to eq :belongs_to
      end

      it "結合モデルのクラスはUser" do
        expect(association.class_name).to eq 'User'
      end
    end

    context 'Userモデル(followed)との関連' do
      let(:target) { :followed }

      it '多対1である' do
        expect(association.macro).to eq :belongs_to
      end

      it "結合モデルのクラスはUser" do
        expect(association.class_name).to eq 'User'
      end
    end
  end
end
