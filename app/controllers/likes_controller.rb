class LikesController < ApplicationController
  before_action :set_like
  
  def create
    like = current_user.likes.build(place_id: params[:place_id])
    like.save
  end
  
  def destroy
    like = Like.find_by(place_id: params[:place_id], user_id: current_user.id)
    like.destroy
  end
  
  def set_like
    @place = Place.find(params[:place_id])
  end
end
