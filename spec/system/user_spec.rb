require 'rails_helper'

RSpec.describe User, type: :system do
  let(:user) { FactoryBot.create(:user) }

  describe "ユーザー登録ページ" do
    before do
      visit new_user_path
    end

    context "ページレイアウト" do
      it "「ユーザー登録」の文字列が存在することを確認" do
        expect(page).to have_content 'ユーザー登録'
      end
    end

    context "フォームの入力が正しい時" do
      it "登録に成功し、フラッシュメッセージを表示する" do
        fill_in "user[name]", with: "name"
        fill_in "user[email]", with: "test@example.com"
        fill_in "user[password]", with: "password"
        fill_in "user[password_confirmation]", with: "password"
        click_on "登録する"
        expect(page).to have_content "ユーザ「name」を登録しました。"
        expect(current_path).to eq places_path
      end
    end

    context "フォームでnameが空欄の場合" do
      it "登録に失敗し、エラーメッセージを表示する" do
        fill_in "user[name]", with: ""
        fill_in "user[email]", with: "test@example.com"
        fill_in "user[password]", with: "password"
        fill_in "user[password_confirmation]", with: "password"
        click_on "登録する"
        expect(page).to have_content "名前を入力してください"
      end
    end

    context "フォームでemailが空欄の場合" do
      example "登録に失敗し、エラーメッセージを表示する" do
        fill_in "user[name]", with: "name"
        fill_in "user[password]", with: "password"
        fill_in "user[password_confirmation]", with: "password"
        click_on "登録する"
        expect(page).to have_content "メールアドレスを入力してください"
      end
    end

    context "フォームでpasswordが空欄の場合" do
      example "登録に失敗し、エラーメッセージを表示する" do
        fill_in "user[name]", with: "name"
        fill_in "user[email]", with: "test@example.com"
        fill_in "user[password_confirmation]", with: "password"
        click_on "登録する"
        expect(page).to have_content "パスワードを入力してください"
      end
    end

    context "フォームでpassword_confirmationが空欄の場合" do
      example "登録に失敗し、エラーメッセージを表示する" do
        fill_in "user[name]", with: "name"
        fill_in "user[email]", with: "test@example.com"
        fill_in "user[password]", with: "password"
        click_on "登録する"
        expect(page).to have_content "パスワード(確認)とパスワードの入力が一致しません"
      end
    end

    context "フォームでpasswordとpassword_confirmationが一致しない場合" do
      example "登録に失敗し、エラーメッセージを表示する" do
        fill_in "user[name]", with: "name"
        fill_in "user[email]", with: "test@example.com"
        fill_in "user[password]", with: "password"
        fill_in "user[password_confirmation]", with: "pass"
        click_on "登録する"
        expect(page).to have_content "パスワード(確認)とパスワードの入力が一致しません"
      end
    end
  end

  describe "ログインページ" do
    before do
      visit login_path
    end

    context "ページレイアウト" do
      it "「ログイン」の文字列が存在することを確認" do
        expect(page).to have_content 'ログイン'
      end
    end

    context "フォームの入力が正しい時" do
      it "ログインに成功し、フラッシュメッセージを表示する" do
        fill_in "session[email]", with: "#{ user.email }"
        fill_in "session[password]", with: "password"
        click_button "ログインする"
        expect(page).to have_content "ログインしました。"
        expect(current_path).to eq places_path
      end
    end
  end

  describe "ユーザー情報編集ページ" do
    before do
      visit login_path
      fill_in "session[email]", with: "#{ user.email }"
      fill_in "session[password]", with: "password"
      click_on "ログインする"
      visit edit_user_path(user)
    end

    context "ページレイアウト" do
      it "「ユーザー編集」の文字列が存在することを確認" do
        expect(page).to have_content 'ユーザー編集'
      end
    end

    context "フォームの入力が正しい時" do
      it "編集に成功し、フラッシュメッセージを表示する" do
        fill_in "user[name]", with: "edit_name"
        click_on "登録する"
        expect(page).to have_content "ユーザ「edit_name」を更新しました"
        expect(current_path).to eq user_path( user.id )
      end
    end

    context "フォームの入力が誤っている時" do
      it "登録に失敗し、エラーメッセージを表示する" do
        fill_in "user[name]", with: ""
        click_on "登録する"
        expect(page).to have_content "名前を入力してください"
      end
    end
  end
end