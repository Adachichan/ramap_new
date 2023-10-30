class Admin::CommentsController < ApplicationController

  def index
    @review = Review.find(params[:review_id])
    @comments = @review.comments.page(params[:page]).per(10)
    # ページごとのNo加算値の決定
    # params[:page] → 現在表示しているページ(※1ページ目はnil)
    # if params[:page]
    # params[:page]の中が数値 → trueとして評価
    # params[:page]の中がnil  → falseとして評価
    # page = params[:page]&.to_i
    # (params[:page].to_i - 1)
    # true(2ページ目以降) → 先頭の数値が、page - 1 × 10 + 1 (+ 1は後で加算)
    if params[:page]
      @number = (params[:page].to_i - 1) * 10
    else
      @number = 0
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    if comment
      comment.destroy
    end
    redirect_to admin_review_comments_path(comment.review_id)
  end

end
