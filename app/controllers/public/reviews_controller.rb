class Public::ReviewsController < ApplicationController

  before_action :identify_review, only: [:show]

  def new
    @store = Store.find(params[:store_id])

    # 自身が投稿した店舗に対する投稿画面へのアクセスを防止する（URL直接入力）
    if @store.user_id == current_user.id
      redirect_to store_reviews_path(@store.id)
    end

    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.store_id = params[:store_id]
    @review.user_id = current_user.id
    @review.name = current_user.name
    @review.nickname = current_user.nickname

    # 口コミの保存可否
    if @review.save
      # 2023/12/11追加（フラッシュメッセージ）
      flash[:notice] = "投稿に成功しました。"
      redirect_to store_review_path(@review.store_id, @review.id)
    else
      @store = Store.find(params[:store_id])
      # 2023/12/11追加（フラッシュメッセージ）
      flash.now[:alert] = "投稿に失敗しました。"
      render :new
    end
  end

  def index
    @store = Store.find(params[:store_id])
    @reviews_number = @store.reviews.count
    @reviews = @store.reviews.page(params[:page]).per(10)
  end

  def show
    @comment = Comment.new
    @comments = @review.comments.page(params[:page]).per(10)
  end

  def history
    @reviews = current_user.reviews.page(params[:page]).per(10)

    if params[:page]
      @number = (params[:page].to_i - 1) * 10
    else
      @number = 0
    end
  end

  private

  def review_params
    params.require(:review).permit(:visit_date, :title, :content, :score, :review_image)
  end

  def identify_review
    @review = Review.find(params[:id])
  end

end
