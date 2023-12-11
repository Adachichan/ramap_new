class Public::MymenusController < ApplicationController

  before_action :authenticate_user!
  before_action :identify_mymenu, only: [:edit, :update, :destroy]

  def index
    @mystore = Store.find(params[:mystore_id])

    # 他ユーザーからのアクセスを制限する
    unless @mystore.user_id == current_user.id
      redirect_to mystores_path
    end

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

    # 他ユーザーからのアクセスを制限する
    unless @mymenu.store.user_id == current_user.id
      redirect_to mystores_path
    end

    # 店舗ジャンルの保存可否
    if @mymenu.save
      # 2023/12/09追加（フラッシュメッセージ）
      flash[:notice] = "登録に成功しました。"
      redirect_to mystore_mymenus_path(@mymenu.store_id)
    else
      @mystore = Store.find(params[:mystore_id])
      @mymenus = @mystore.menus.page(params[:page]).per(10)
      if params[:page]
        @number = (params[:page].to_i - 1) * 10
      else
        @number = 0
      end
      # 2023/12/09追加（フラッシュメッセージ）
      flash.now[:alert] = "登録に失敗しました。"
      render :index
    end
  end

  def edit
  end

  def update
    # メニュー情報の更新可否
    if @mymenu.update(mymenu_params)
      # 2023/12/09追加（フラッシュメッセージ）
      flash[:notice] = "更新に成功しました。"
      redirect_to mystore_mymenus_path(@mymenu.store_id)
    else
      # 2023/12/09追加（フラッシュメッセージ）
      flash.now[:alert] = "更新に失敗しました。"
      render :edit
    end
  end

  def destroy
    # メニューの削除可否_2023/12/11追加
    if @mymenu.destroy
      # 2023/12/11追加（フラッシュメッセージ）
      flash[:notice] = "削除しました。"
      redirect_to mystore_mymenus_path(@mymenu.store_id)
    else
      @mystore = Store.find(params[:mystore_id])
      @mymenus = @mystore.menus.page(params[:page]).per(10)
      if params[:page]
        @number = (params[:page].to_i - 1) * 10
      else
        @number = 0
      end
      # 2023/12/11追加（フラッシュメッセージ）
      flash.now[:alert] = "削除できませんでした。"
      render :index
    end
  end

  def destroy_all
    @mystore = Store.find(params[:mystore_id])

    # 他ユーザーからのアクセスを制限する
    unless @mystore.user_id == current_user.id
      redirect_to mystores_path
    end

    # メニューの全削除可否_2023/12/11追加
    if @mystore.menus.destroy_all
      # 2023/12/11追加（フラッシュメッセージ）
      flash[:notice] = "全て削除しました。"
      redirect_to mystore_mymenus_path(@mystore.id)
    else
      @mymenu = Menu.find(params[:id])
      @mymenus = @mystore.menus.page(params[:page]).per(10)
      if params[:page]
        @number = (params[:page].to_i - 1) * 10
      else
        @number = 0
      end
      # 2023/12/11追加（フラッシュメッセージ）
      flash.now[:alert] = "削除できませんでした。"
      render :index
    end
  end

  private

  def mymenu_params
    params.require(:menu).permit(:menu_image, :name, :price)
  end

  def identify_mymenu
    @mymenu = Menu.find(params[:id])

    # 他ユーザーからのアクセスを制限する
    unless @mymenu.store.user_id == current_user.id
      redirect_to mystores_path
    end
  end

end
