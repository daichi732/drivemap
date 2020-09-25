class CommentsController < ApplicationController
  before_action :login_required
  def create
    @place = Place.find(params[:place_id])
      #投稿に紐づいたコメントを作成
    @comment = @place.comments.new(comment_params)
    if @comment.save
      render :index
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      render :index
    end
  end

  #formにてplace_idパラメータを送信,mergeでuser_idを格納
  private
  def comment_params
    params.require(:comment).permit(:content, :date, :place_id).merge(user_id: current_user.id)
  end
end
