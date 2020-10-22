require 'rails_helper'
RSpec.describe Comment, type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:place) { FactoryBot.create(:place) }

  describe "場所の登録ページ" do
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
  end
end