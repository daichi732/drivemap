require 'rails_helper'
RSpec.describe Relationship, type: :system do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }

  before do
    create(:relationship, follower_id: user.id, followed_id: user2.id)
    create(:relationship, follower_id: user.id, followed_id: user3.id)
    create(:relationship, follower_id: user2.id, followed_id: user.id)
    visit login_path
    fill_in "session[email]", with: user.email
    fill_in "session[password]", with: user.password
    click_on "ログインする"
  end

  describe "プロフィールページ" do
    before do
      visit user_path(user)
    end
    
    context "ページレイアウト" do
      it "フォローフォロワー数の表示" do
        expect(page).to have_content "フォロー:#{ user.following.count }"
        expect(page).to have_content "フォロワー:#{ user.followers.count }"
      end
    end
  end

  describe "フォローページ" do
    before do
      visit following_user_path(user)
    end

    context "ページレイアウト" do
      it "フォローページに正しい文字列が存在することを確認" do
        expect(page).to have_content "#{ user.name }さんがフォロー中"
      end

      it "フォロー中のユーザーが表示されていること" do
        expect(page).to have_content user2.name
        expect(page).to have_content user3.name
      end
    end
  end

  describe "フォロワーページ" do
    before do
      visit followers_user_path(user)
    end

    context "ページレイアウト" do
      it "フォロワーページに正しい文字列が存在することを確認" do
        expect(page).to have_content "#{ user.name }さんのフォロワー"
      end

      it "フォロワーが表示されていること" do
        expect(page).to have_content user2.name
      end
    end
  end
end