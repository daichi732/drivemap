require 'rails_helper'

RSpec.describe Like, type: :model do
  it "user_id, place_idがある場合有効であること" do
    # idに値を入れてbuildする
    expect(FactoryBot.build_stubbed(:like)).to be_valid
  end
end
