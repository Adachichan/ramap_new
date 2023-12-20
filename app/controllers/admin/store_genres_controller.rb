class Admin::StoreGenresController < ApplicationController

  before_action :authenticate_admin!
  before_action :identify_genre, only: [:edit, :update]

  def index
    @store_genre = StoreGenre.new
    @store_genres = StoreGenre.page(params[:page]).per(10)
  end

  def create
    @store_genre = StoreGenre.new(store_genre_params)
    # 店舗ジャンルの保存可否
    if @store_genre.save
      # 2023/12/20追加（フラッシュメッセージ）
      flash[:notice] = "登録に成功しました。"
      redirect_to admin_store_genres_path
    else
      @store_genres = StoreGenre.page(params[:page]).per(10)
      # 2023/12/20追加（フラッシュメッセージ）
      flash.now[:alert] = "登録に失敗しました。"
      render :index
    end
  end

  def edit
  end

  def update
    # 店舗ジャンルの更新可否
    if @store_genre.update(store_genre_params)
      redirect_to admin_store_genres_path
    else
      render :edit
    end
  end

  private

  def store_genre_params
    params.require(:store_genre).permit(:name)
  end

  def identify_genre
    @store_genre = StoreGenre.find(params[:id])
  end

end