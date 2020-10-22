require 'rails_helper'
RSpec.describe Comment, type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:place) { FactoryBot.create(:place) }

  describe "コメント機能" do
    before do
      visit login_path
      fill_in "session[email]", with: user.email # 作成されたplaceのuserでログインする
      fill_in "session[password]", with: user.password
      click_on "ログインする"
      visit place_path(place)
    end

    context "空欄でコメントすると" do
      it "コメントに失敗し、エラーメッセージを表示する", js: true do
        click_on 'コメントする'
        expect(page).to have_content "コメントを入力してください"
      end 
    end

    context "正しくコメントすると" do
      it "コメント内容とそのユーザーがマイページで表示されること", js: true do
        fill_in "comment[content]", with: "foobar"
        click_on 'コメントする'
        expect(page).to have_link user.name, href: user_path(user)
        expect(page).to have_content "foobar"
      end 
    end
  end
end