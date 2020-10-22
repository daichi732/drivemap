require 'rails_helper'
RSpec.describe Relationship, type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }
  let(:user3) { FactoryBot.create(:user) }
  before do
    FactoryBot.create(:relationship, follower_id: user.id, followed_id: user2.id)
    FactoryBot.create(:relationship, follower_id: user.id, followed_id: user3.id)
    FactoryBot.create(:relationship, follower_id: user2.id, followed_id: user.id)
    visit login_path
    fill_in "session[email]", with: user.email
    fill_in "session[password]", with: user.password
    click_on "ログインする"
  end

  describe "プロフィールページ" do
    context "ページレイアウト" do
      before do
        visit user_path(user)
      end
  
      it "フォローフォロワー数の表示" do
        expect(page).to have_content 'フォロー:2'
        expect(page).to have_content 'フォロワー:1'
      end
    end
  end

  describe "フォローページ" do
    before do
      visit following_user_path(user)
    end

    context "ページレイアウト" do
      it "「testUserさんがフォロー中」の文字列が存在することを確認" do
        expect(page).to have_content 'testUserさんがフォロー中'
      end

      it "フォロー中のユーザーが表示されていること" do
        expect(page).to have_content user2.name, href: user_path(user2)
        expect(page).to have_content user3.name, href: user_path(user3)
      end
    end
  end

  describe "フォロワーページ" do
    before do
      visit followers_user_path(user)
    end

    context "ページレイアウト" do
      it "「testUserさんのフォロワー」の文字列が存在することを確認" do
        expect(page).to have_content 'testUserさんのフォロワー'
      end

      it "フォロワーが表示されていること" do
        expect(page).to have_content user2.name, href: user_path(user2)
      end
    end
  end
end