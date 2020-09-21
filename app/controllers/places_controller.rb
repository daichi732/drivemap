class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy]

  def index
    @places = Place.all.recent
  end

  def show
  end

  def new
    @place = Place.new
  end

  def create
    @place = current_user.places.build(place_params)
    if @place.save
      redirect_to @place, notice: "場所「#{@place.name}」を登録しました。"
    else
      flash.now[:notice] = "場所が登録できませんでした。"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @place.update(place_params)
      redirect_to @place, notice: "場所「#{@place.name}」を更新しました。"
    else
      flash.now[:notice] = "場所が更新できませんでした。"
      render 'edit'
    end
  end

  def destroy
    @place.destroy
    redirect_to places_url, notice: "場所「#{@place.name}」を削除しました。"
  end

  private
    def place_params
      params.require(:place).permit(:name, :description)
    end

    def set_place
      @place = Place.find(params[:id])
    end
end