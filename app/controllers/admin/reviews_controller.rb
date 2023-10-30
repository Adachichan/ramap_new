class Admin::ReviewsController < ApplicationController

  before_action :identify_review, only: [:show, :destroy]

  def index
    # indexページの表示画面を判別
    if params[:user_id]
      @user = User.find(params[:user_id])
      all_review = @user.reviews
      # index画面(admin)のflag
      @index_screen_flag = 1

    elsif params[:store_id]
      @store = Store.find(params[:store_id])
      all_review = @store.reviews
      # index画面(admin)のflag
      @index_screen_flag = 2

    else
      all_review = Review.all
      # index画面(admin)のflag
      @index_screen_flag = 0
    end

    @reviews = all_review.page(params[:page]).per(10)

    if @index_screen_flag == 1 || @index_screen_flag == 2
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
    
  end

  def show
  end

  def destroy
    if @review
      @review.destroy
    end
    redirect_to admin_reviews_path
  end

  private

  def identify_review
    @review = Review.find(params[:id])
  end

end
