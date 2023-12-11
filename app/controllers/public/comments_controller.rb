class Public::CommentsController < ApplicationController

  def create
    @review = Review.find(params[:review_id])
    @comment = Comment.new(comment_params)
    @comment.review_id = @review.id
    @comment.poster = current_user.nickname

    # コメントの保存可否
    if @comment.save
      # 2023/12/11追加（フラッシュメッセージ）
      flash[:notice] = "投稿に成功しました。"
      redirect_to store_review_path(@review.store_id, @review.id)
    else
      @comments = @review.comments.page(params[:page]).per(10)
      # 2023/12/11追加（フラッシュメッセージ）
      flash.now[:alert] = "投稿に失敗しました。"
      render "public/reviews/show"
    end

  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

end
