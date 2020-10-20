require 'rails_helper'

RSpec.describe User, type: :system do
  describe "ユーザー登録ページ" do
    before do
      visit new_user_path
    end

    context "ページレイアウト" do
      it "「ユーザー登録」の文字列が存在することを確認" do
        expect(page).to have_content 'ユーザー登録'
      end
    end
  end
end