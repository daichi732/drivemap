require 'rails_helper'

RSpec.describe Schedule, type: :model do
  describe "バリデーションのテスト" do
    let(:schedule) { FactoryBot.build(:schedule) }

    it "user_id, place_id, dateがある場合有効であること" do
      expect(FactoryBot.build_stubbed(:schedule)).to be_valid
    end

    it "user_idがない場合無効であること" do
      schedule.user_id = nil
      schedule.valid?
      expect(schedule.errors[:user_id]).to include("を入力してください")
    end

    it "place_idがない場合無効であること" do
      schedule.place_id = nil
      schedule.valid?
      expect(schedule.errors[:place_id]).to include("を入力してください")
    end

    it "dateがない場合無効であること" do
      schedule.date = nil
      schedule.valid?
      expect(schedule.errors[:date]).to include("を入力してください")
    end
  end

  describe "アソシエーションのテスト" do
    let(:association) do
      # Scheduleクラスと引数のクラスの関連を返す
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
