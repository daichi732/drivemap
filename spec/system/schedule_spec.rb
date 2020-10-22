require 'rails_helper'
RSpec.describe Schedule, type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:place) { FactoryBot.create(:place) }
  let(:schedule) { FactoryBot.create(:schedule) }


  describe "場所の詳細ページ" do
    before do
      visit login_path
      fill_in "session[email]", with: user.email # 作成されたplaceのuserでログインする
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

    # context "正しく日時を登録すると" do
    #   it "登録した場所の日時、名称がマイページで表示されること", js: true do
    #     fill_in "schedule[date]", with: "2020/02/25 00:00"
    #     click_on '登録する'
    #     visit user_path(user)
    #     # expect(page).to have_content schedule.date
    #     expect(page).to have_content "2020/02/25 00:00"
    #     expect(page).to have_content place.name
    #   end 
    # end
  end
end