class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :login_required, only: %i[index show edit update destroy]
  before_action :correct_user, only: %i[edit update]
  before_action :require_admin, only: %i[index destroy]

  def index
    @users = User.all
  end

  def show
    @places = @user.places.recent # ユーザが登録した場所一覧表示
    @likes = Like.where(user_id: @user.id) # いいね一覧表示
    place_ids = @likes.pluck(:place_id) # いいねしたLikeデータのplace_idカラムの集合
    @like_places = Place.where(id: place_ids)
    gon.places = @like_places
    @comments = @user.comments
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

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def correct_user
    redirect_to places_url unless @user == current_user
  end

  def require_admin
    redirect_to places_url unless current_user.admin?
  end
end
