require 'rails_helper'
RSpec.describe Comment, type: :system do
  let(:user) { create(:user) }
  let(:place) { create(:place) }

  describe "コメント機能" do
    before do
      visit login_path
      fill_in "session[email]", with: user.email
      fill_in "session[password]", with: user.password
      click_on "ログインする"
      visit place_path(place)
    end

    context "空欄でコメントした場合" do
      it "失敗し、エラーメッセージを表示する", js: true do
        click_on 'コメントする'
        expect(page).to have_content "コメントを入力してください"
      end 
    end

    context "正しくコメントした場合" do
      it "コメント結果が反映されること", js: true do
        fill_in "comment[content]", with: "foobar"
        click_on 'コメントする'
        expect(page).to have_link user.name, href: user_path(user)
        expect(page).to have_content "foobar"
        expect(page).to have_selector ".fas.fa-trash"
      end 
    end
  end
end