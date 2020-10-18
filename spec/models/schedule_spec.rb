require 'rails_helper'

RSpec.describe Schedule, type: :model do
  it "user_id, place_id, dateがある場合有効であること" do
    expect(FactoryBot.build_stubbed(:schedule)).to be_valid
  end

  it "user_idがない場合無効であること" do
    schedule = FactoryBot.build(:schedule, user_id: nil)
    schedule.valid?
    expect(schedule.errors[:user_id]).to include("を入力してください")
  end

  it "place_idがない場合無効であること" do
    schedule = FactoryBot.build(:schedule, place_id: nil)
    schedule.valid?
    expect(schedule.errors[:place_id]).to include("を入力してください")
  end

  it "dateがない場合無効であること" do
    schedule = FactoryBot.build(:schedule, date: nil)
    schedule.valid?
    expect(schedule.errors[:date]).to include("を入力してください")
  end
end
