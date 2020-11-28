class CommentsController < ApplicationController
  before_action :login_required
  def create
    @place = Place.find(params[:place_id])
    @comment = @place.comments.new(comment_params)
    if @comment.save
      render :index
    else
      render :error
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    render :index if @comment.destroy
  end

  private

  def comment_params
    # formにてplace_idパラメータを送信,mergeでuser_idを格納
    params.require(:comment).permit(:content, :place_id).merge(user_id: current_user.id)
  end
end
