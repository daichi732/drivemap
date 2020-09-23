class CommentsController < ApplicationController
  def create
    @place = Place.find(params[:place_id])
      #投稿に紐づいたコメントを作成
    @comment = @place.comments.build(comment_params)
    @comment.user_id = current_user.id
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

  #formにてplace_idパラメータを送信して、コメントへplace_idを格納する
  private
  def comment_params
    params.require(:comment).permit(:content, :date, :place_id, :user_id)  
  end
end
