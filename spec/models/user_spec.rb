require 'rails_helper'

RSpec.describe User, type: :model do
  it "名前、メールアドレス、パスワードがある場合有効であること" do
    user = User.new(name: "testUser", email: "testemail", password: "testPassword")
    expect(user).to be_valid
  end

  it "名前がない場合無効であること" do # to_not, validatesのコメントアウト
    user = User.new(name: nil)
    user.valid?
    expect(user.errors[:name]).to include("を入力してください")
  end

  it "名前が21文字の場合無効であること" do # to_not, validatesのコメントアウト
    user = User.new(name: "a" * 21)
    user.valid?
    expect(user.errors[:name]).to include("は20文字以内で入力してください")
  end

  it "メールアドレスがない場合無効であること" do
    user = User.new(email: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  it "重複したメールアドレスなら無効な状態であること" do
    User.create(name: "testUser", email: "testemail", password: "testPassword")
    user = User.new(email: "testemail")
    user.valid?
    expect(user.errors[:email]).to include("はすでに存在します")
  end

  it "メールアドレスは小文字で保存されること" do
    email = "TestEmail"
    user = User.create(name: "testUser", email: email, password: "testPassword")
    expect(user.email).to eq email.downcase
  end

  it "パスワードがない場合無効であること" do
    user = User.new(password: nil)
    user.valid?
    expect(user.errors[:password]).to include("を入力してください")
  end

  
  # context "バリデーション" do
  #   it "名前がない場合無効" do
  #   end
  # end
end
