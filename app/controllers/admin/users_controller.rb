class Admin::UsersController < ApplicationController

  before_action :authenticate_admin!
  before_action :identify_user, only: [:show, :edit, :update]

  def index
    @users = User.page(params[:page]).per(10)
  end

  def show
  end

  def edit
  end

  def update
    # user情報の更新可否
    if @user.update(user_params)
      # 2023/12/20追加（フラッシュメッセージ）
      flash[:notice] = "更新に成功しました。"
      redirect_to admin_user_path(@user.id)
    else
      # コメント：編集画面において、名前が表示されない・・・（改善点）
      # 2023/12/20追加（フラッシュメッセージ）
      flash.now[:alert] = "更新に失敗しました。"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :name_kana, :nickname, :postal_code, :address, :sex, :telephone_number, :email, :is_deleted)
  end

  def identify_user
    @user = User.find(params[:id])
  end

end
