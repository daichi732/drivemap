class PlacesController < ApplicationController
  before_action :set_place, only: %i[show edit update destroy]
  before_action :login_required
  before_action :correct_user, only: %i[edit update]

  def index
    @q = Place.ransack(params[:q])
    @places = @q.result.includes(user: { avatar_attachment: :blob }, image_attachment: :blob).page(params[:page]).recent
    gon.places = @places # 検索結果のマップ表示用
  end

  def show
    @comment = Comment.new # 'comments/form'レンダリングで渡す
    @comments = @place.comments.order(created_at: :desc) # 'comments/index'レンダリングで渡す
    gon.place = @place
    @schedule = Schedule.new
    @my_schedule = current_user.schedules.where(place_id: @place.id) # current_userしか見れない設定
  end

  def new
    @place = Place.new
  end

  def create
    @place = current_user.places.new(place_params)
    @place.image.attach(params[:place][:image])
    if @place.save
      redirect_to @place, notice: "「#{@place.name}」を登録しました。"
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @place.update(place_params)
      redirect_to @place, notice: "「#{@place.name}」を更新しました。"
    else
      render 'edit'
    end
  end

  def destroy
    @place.destroy
    redirect_to places_url, notice: "「#{@place.name}」を削除しました。"
  end

  private

  def place_params
    params.require(:place).permit(:name, :description, :image, :address, :genre)
  end

  def set_place
    @place = Place.find(params[:id])
  end

  def correct_user
    redirect_to places_url, notice: "権限がありません。" unless current_user.own?(@place)
  end
end
