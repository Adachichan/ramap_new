class Public::MymenusController < ApplicationController

  before_action :authenticate_user!
  before_action :identify_mymenu, only: [:edit, :update, :destroy]

  def index
    @mystore = Store.find(params[:mystore_id])
    @mymenu = Menu.new
    # 店舗ごとの全メニューを取得
    @mymenus = @mystore.menus.page(params[:page]).per(10)
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

  def create
    @mymenu = Menu.new(mymenu_params)
    @mymenu.store_id = params[:mystore_id]
    # 店舗ジャンルの保存可否
    if @mymenu.save
      redirect_to mystore_mymenus_path(@mymenu.store_id)
    else
      @mystore = Store.find(params[:mystore_id])
      @mymenus = @mystore.menus.page(params[:page]).per(10)
      if params[:page]
        @number = (params[:page].to_i - 1) * 10
      else
        @number = 0
      end
      render :index
    end
  end

  def edit
  end

  def update
    # メニュー情報の更新可否
    if @mymenu.update(mymenu_params)
      redirect_to mystore_mymenus_path(@mymenu.store_id)
    else
      render :edit
    end
  end

  def destroy
    @mymenu.destroy
    redirect_to mystore_mymenus_path(@mymenu.store_id)
  end

  def destroy_all
    mystore = Store.find(params[:mystore_id])
    mystore.menus.destroy_all
    redirect_to mystore_mymenus_path(mystore.id)
  end

  private

  def mymenu_params
    params.require(:menu).permit(:menu_image, :name, :price)
  end

  def identify_mymenu
    @mymenu = Menu.find(params[:id])
  end

end
