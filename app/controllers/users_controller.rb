class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: "ユーザ「#{@user.name}」を登録しました。"
    else
      flash.now[:notice] = "ユーザが登録できませんでした。"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "ユーザ「#{@user.name}」を更新しました。"
    else
      flash.now[:notice] = "ユーザが更新できませんでした。"
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
end
