require 'rails_helper'
RSpec.describe Like, type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:place) { FactoryBot.create(:place) }

  describe "いいね機能" do
    before do
      visit login_path
      fill_in "session[email]", with: user.email # 作成されたplaceのuserでログインする
      fill_in "session[password]", with: user.password
      click_on "ログインする"
      visit place_path(place)
    end

    context "場所の詳細ページで" do
      it "いいねの作成、解除が動作すること", js: true do
        find('.far.fa-heart').click
        expect(page).to have_selector '.fas.fa-heart'
        expect(place.likes.count).to eq(1)

        find('.fas.fa-heart').click
        expect(page).to have_selector '.far.fa-heart'
        expect(place.likes.count).to eq(0)
      end 

      it "いいねした場所がマイページで表示されること", js: true do
        find('.far.fa-heart').click
        visit user_path(user)
        click_on 'いいね一覧'
        expect(page).to have_content place.name
      end 
    end
  end
end