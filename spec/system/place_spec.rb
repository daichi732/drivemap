require 'rails_helper'
RSpec.describe Place, type: :system do
  let(:user) { FactoryBot.create(:user) }
  # この2つで2人のユーザーとその人のplaceが作成、どっちでもいいときuserを使い、place絡めるときはplace.user, other_place.user
  let(:place) { FactoryBot.create(:place) }
  let(:other_place) { FactoryBot.create(:place) }
  
  describe "場所の登録ページ" do
    before do
      visit login_path
      fill_in "session[email]", with: user.email
      fill_in "session[password]", with: user.password
      click_on "ログインする"
      visit new_place_path
    end

    context "ページレイアウト" do
      it "「場所を登録する」の文字列が存在することを確認" do
        expect(page).to have_content '場所を登録する'
      end
    end

    context "フォームの入力が正しい時" do
      it "登録に成功し、フラッシュメッセージを表示する" do
        fill_in "place[name]", with: "箱根ガラスの森美術館"
        find('label[for=place_genre_food]').click 
        fill_in "place[address]", with: "箱根ガラスの森美術館"
        click_on "登録する"
        expect(page).to have_content "「箱根ガラスの森美術館」を登録しました。"
        # expect(current_path).to eq place_path( place.id )これでは違うplace
      end
    end

    context "フォームでnameが空欄の場合" do
      it "登録に失敗し、エラーメッセージを表示する" do
        fill_in "place[name]", with: ""
        find('label[for=place_genre_food]').click 
        fill_in "place[address]", with: "箱根ガラスの森美術館"
        click_on "登録する"
        expect(page).to have_content "名称を入力してください"
      end
    end

    context "フォームでemailが空欄の場合" do
      example "登録に失敗し、エラーメッセージを表示する" do
        fill_in "place[name]", with: "箱根ガラスの森美術館"
        # find('label[for=place_genre_food]').click 
        fill_in "place[address]", with: "箱根ガラスの森美術館"
        click_on "登録する"
        expect(page).to have_content "種類を入力してください"
      end
    end

    context "フォームでpasswordが空欄の場合" do
      example "登録に失敗し、エラーメッセージを表示する" do
        fill_in "place[name]", with: "箱根ガラスの森美術館"
        find('label[for=place_genre_food]').click 
        fill_in "place[address]", with: ""
        click_on "登録する"
        expect(page).to have_content "住所を入力してください"
      end
    end
  end

  describe "場所の編集ページ" do
    before do
      visit login_path
      fill_in "session[email]", with: place.user.email # 作成されたplaceのuserでログインする
      fill_in "session[password]", with: place.user.password
      click_on "ログインする"
      visit edit_place_path(place)
    end

    context "ページレイアウト" do
      it "「場所を編集する」の文字列が存在することを確認" do
        expect(page).to have_content '場所を編集する'
      end
    end

    # 違うuserでログインして権限がありませんのテストも
    context "フォームの入力が正しい時" do
      it "編集に成功し、フラッシュメッセージを表示する" do
        fill_in "place[name]", with: "edit_place"
        find('label[for=place_genre_food]').click 
        fill_in "place[address]", with: "箱根ガラスの森美術館"
        click_on "更新する"
        expect(page).to have_content "「edit_place」を更新しました。"
        expect(page).to have_content "edit_place"
        # expect(current_path).to eq place_path( place.id )
      end
    end
  end

  describe "場所の一覧ページ" do
    before do
      visit login_path
      fill_in "session[email]", with: user.email # 作成されたplaceのuserでログインする
      fill_in "session[password]", with: user.password
      click_on "ログインする"
      visit places_path
    end

    context "ページレイアウト" do
      it "「ALL SPOTS」の文字列が存在することを確認" do
        expect(page).to have_content 'ALL SPOTS'
      end
    end

    # context "場所をクリックすると" do
    #   it "詳細ページに移動できること" do
    #     click_on place.name # testPlaceがない
    #     expect(current_path).to eq place_path( place.id )
    #   end
    # end

    context "「マイページ」をクリックすると" do
      it "マイページに移動できること" do
        click_on 'マイページ'
        expect(current_path).to eq user_path( user.id )
      end
    end

    context "「場所を登録」をクリックすると" do
      it "登録ページに移動できること" do
        click_on '場所を登録'
        expect(current_path).to eq new_place_path
      end
    end

    context "「ログアウト」をクリックすると" do
      it "ログアウトし、フラッシュメッセージを表示する" do
        click_on 'ログアウト'
        expect(current_path).to eq root_path
        expect(page).to have_content "ログアウトしました。"
      end
    end
  end

  describe "場所の詳細ページ" do
    context "ログインユーザーが自分の詳細ページを見る場合" do
      before do
        visit login_path
        fill_in "session[email]", with: place.user.email # 作成されたplaceのuserでログインする
        fill_in "session[password]", with: place.user.password
        click_on "ログインする"
        visit place_path(place)
      end
  
      context "ページレイアウト" do
        it "場所の名前の文字列が存在することを確認" do
          expect(page).to have_content place.name
        end
      end
  
      context "「編集」をクリックすると" do
        it "場所の編集ページに移動できること" do
          click_on '編集'
          expect(current_path).to eq edit_place_path( place.id )
        end
      end

      context "「削除」をクリックすると" do
        it "削除が正常に動作すること" do
          expect(place.user.places.count).to eq(1)
          click_on '削除'
          expect(page).to have_content '「testPlace」を削除しました'
          expect(place.user.places.count).to eq(0)
          expect(current_path).to eq places_path
        end
      end
  
      context "「一覧」をクリックすると" do
        it "一覧ページに移動できること" do
          click_on '一覧'
          expect(current_path).to eq places_path
        end
      end
  
      context "いいね" do
        it "いいねの作成、解除が動作すること", js: true do
          find('.far.fa-heart').click
          expect(page).to have_selector '.fas.fa-heart'
          expect(place.likes.count).to eq(1)
  
          find('.fas.fa-heart').click
          expect(page).to have_selector '.far.fa-heart'
          expect(place.likes.count).to eq(0)
        end 
      end
  
      context "空欄でコメントすると" do
        it "コメントに失敗し、エラーメッセージを表示する", js: true do
          click_on 'コメントする'
          expect(page).to have_content "コメントを入力してください"
        end 
      end
  
      context "空欄で日時を登録すると" do
        it "登録に失敗し、エラーメッセージを表示する", js: true do
          click_on '登録する'
          expect(page).to have_content "日時を入力してください"
        end 
      end
    end

    context "ログインユーザーが他のユーザーが登録した場所の詳細ページを見る場合" do
      before do
        visit login_path
        fill_in "session[email]", with: place.user.email
        fill_in "session[password]", with: place.user.password
        click_on "ログインする"
        visit place_path(other_place) # 他のユーザーのplace
      end

      context "ページレイアウト" do
        it "編集、削除が存在しないことを確認" do
          expect(page).to_not have_content '編集'
          expect(page).to_not have_content '削除'
        end
      end
    end
  end
end
