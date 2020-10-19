require 'rails_helper'

RSpec.describe User, type: :model do
  
  it "名前、メールアドレス、パスワードがある場合有効であること" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it "名前がない場合無効であること" do # to_not, validatesのコメントアウト
    # user = User.new(name: nil)
    user = FactoryBot.build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include("を入力してください")
  end

  it "名前が21文字の場合無効であること" do # to_not, validatesのコメントアウト
    # user = User.new(name: "a" * 21)
    user = FactoryBot.build(:user, name: "a" * 21)
    user.valid?
    expect(user.errors[:name]).to include("は20文字以内で入力してください")
  end

  it "メールアドレスがない場合無効であること" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  it "重複したメールアドレスなら無効な状態であること" do
    user = FactoryBot.create(:user)
    # シーケンスのおかげ
    other_user = FactoryBot.build(:user, email: user.email)
    other_user.valid?
    expect(other_user.errors[:email]).to include("はすでに存在します")
  end

  it "メールアドレスは小文字で保存されること" do
    email = "ExamPle@Example.coM"
    user = FactoryBot.create(:user, email: email)
    expect(user.email).to eq email.downcase
  end

  it "パスワードがない場合無効であること" do
    user = FactoryBot.build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("を入力してください")
  end

  it "プロフィール画像が登録できること" do
    user = FactoryBot.build(:user)
    user.avatar = fixture_file_upload("/files/test_image.png")
    expect(user).to be_valid
  end

  it "プロフィール画像がjpeg/gif/pngでない場合無効であること" do
    user = FactoryBot.build(:user)
    user.avatar = fixture_file_upload("/files/invalid_file.txt")
    user.valid?
    expect(user.errors[:avatar]).to include("にはjpegまたはgifまたはpngファイルを添付してください")
  end

  it "フォローとアンフォローが正常に動作すること" do
    user = FactoryBot.create(:user)
    other_user = FactoryBot.create(:user)
    expect(user.following?(other_user)).to be_falsey
    user.follow(other_user)
    expect(user.following?(other_user)).to be_truthy
    user.unfollow(other_user)
    expect(user.following?(other_user)).to be_falsey
  end

  it "Userモデルインスタンスが自分のplaceであることの確認" do
    # 本来 user = FactoryBot.create(:user)アソシエーションあるからいらない！！
    
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)

    # アソシエーションでuserインスタンスも作成されることからcreateにしたいけどimageで引っかかってしまうから
    user1_place = FactoryBot.build(:place, user_id: user1.id)
    user1_place.image = fixture_file_upload("/files/test_image.png")
    user1_place.save

    user2_place = FactoryBot.build(:place, user_id: user2.id)
    user2_place.image = fixture_file_upload("/files/test_image.png")
    user2_place.save

    expect(user1.own?(user1_place)).to be_truthy
    expect(user1.own?(user2_place)).to be_falsey
  end

  it "Userモデルインスタンスが自分のcommentであることの確認" do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)

    common_place = FactoryBot.build(:place)
    common_place.image = fixture_file_upload("/files/test_image.png")
    common_place.save

    user1_comment = FactoryBot.create(:comment, user_id: user1.id, place_id: common_place.id)

    user2_comment = FactoryBot.create(:comment, user_id: user2.id, place_id: common_place.id)

    expect(user1.own?(user1_comment)).to be_truthy
    expect(user1.own?(user2_comment)).to be_falsey
  end

  it "Userモデルインスタンスが自分のscheduleであることの確認" do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)

    common_place = FactoryBot.build(:place)
    common_place.image = fixture_file_upload("/files/test_image.png")
    common_place.save

    user1_schedule = FactoryBot.create(:schedule, user_id: user1.id, place_id: common_place.id)

    user2_schedule = FactoryBot.create(:schedule, user_id: user2.id, place_id: common_place.id)

    expect(user1.own?(user1_schedule)).to be_truthy
    expect(user1.own?(user2_schedule)).to be_falsey
  end



  
  # context "バリデーション" do
  #   it "名前がない場合無効" do
  #   end
  # end
end
