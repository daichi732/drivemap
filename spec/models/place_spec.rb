require 'rails_helper'

RSpec.describe Place, type: :model do
  it "名称、種類、住所がある場合有効であること" do
    place = FactoryBot.build(:place)
    place.image = fixture_file_upload("/files/test_image.png")
    expect(place).to be_valid
  end
end
