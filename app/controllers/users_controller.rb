class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy following followers]
  before_action :login_required, only: %i[index show edit update destroy following followers]
  before_action :correct_user, only: %i[edit update]
  before_action :require_admin, only: %i[index destroy]

  def index
    @users = User.all
  end

  def show
    @places = @user.places.with_attached_image # ユーザの登録場所一覧表示用
    @likes = @user.likes # いいね一覧表示用
    place_ids = @likes.pluck(:place_id) # place_idカラムの集合
    @like_places = Place.where(id: place_ids) # データ表示用
    gon.places = @like_places # いいねmap表示用
    @schedules = @user.schedules.includes([:place]) # カレンダー表示用
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in(@user)
      redirect_to places_url, notice: "ユーザ「#{@user.name}」を登録しました。"
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "ユーザ「#{@user.name}」を更新しました。"
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: "ユーザ「#{@user.name}」を削除しました。"
  end

  # フォローフォロワー一覧表示画面
  def following
    @following_users = @user.following
  end

  def followers
    @followers_users = @user.followers
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :admin)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def correct_user
    redirect_to places_url, notice: "権限がありません。" unless @user == current_user
  end

  def require_admin
    redirect_to places_url, notice: "権限がありません。" unless current_user.admin?
  end
end
