class Public::MystoresController < ApplicationController

  before_action :authenticate_user!
  before_action :identify_mystore, only: [:show, :edit, :update, :closing_confirm, :close]

  def new
    @mystore = Store.new
    @mystore.opening_hours.build
  end

  def create
    @mystore = Store.new(mystore_params)
    @mystore.user_id = current_user.id

    # 店舗情報の保存可否
    if @mystore.save
      redirect_to mystore_path(@mystore.id)
    else
      @mystore.opening_hours.build
      render :new
    end
  end

  def index
    @mystores = current_user.stores.page(params[:page]).per(10)
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

  def show
  end

  def edit
  end

  def update
    # 店舗情報の更新可否
    if @mystore.update(mystore_params)
      redirect_to mystore_path(@mystore.id)
    else
      render :edit
    end
  end

  def closing_confirm
  end

  def close
    @mystore.update(is_closed: true) # 閉店フラグを「退会する」に更新
    redirect_to mystores_path
  end

  private

  def mystore_params
    # opening_hours_attributesが子のモデルに保存する要素
    # :id、:_destroyをつけることで、編集および削除が可能になる
    params.require(:store).permit(
      :name, :name_kana, :postal_code, :prefecture, :address, :building_and_apartment,
      :telephone_number, :fax_number, :store_image, :store_genre_id, :lowest_price_range,
      :highest_price_range, :closest_station,:representative, :representative_kana,
      :representative_email, :note, :staff, :staff_telephone_number, :staff_email, :latitude, :longitude,
      day_ids: [],
      opening_hours_attributes: [:id, :opening_time, :closing_time, :_destroy])
  end

  def identify_mystore
    @mystore = Store.find(params[:id])
  end

end
