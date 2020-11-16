require 'rails_helper'
RSpec.describe Schedule, type: :system do
  let(:user) { create(:user) }
  let(:place) { create(:place) }
  let(:schedule) { create(:schedule) }

  describe "スケジュール機能" do
    before do
      visit login_path
      fill_in "session[email]", with: user.email
      fill_in "session[password]", with: user.password
      click_on "ログインする"
      visit place_path(place)
    end

    context "空欄で日時を登録すると" do
      it "登録に失敗し、エラーメッセージを表示する", js: true do
        click_on '登録する'
        expect(page).to have_content "日時を入力してください"
      end
    end
  end
end
