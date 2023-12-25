class Public::UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_current_user, only: [:show, :edit, :update, :withdraw]

  def show
  end

  def edit
  end

  def update
    # user情報の更新可否
    if @user.update(user_params)
      # 2023/12/20追加（フラッシュメッセージ）
      flash[:notice] = "更新に成功しました。"
      redirect_to mypage_path
    else
      # 2023/12/20追加（フラッシュメッセージ）
      flash.now[:alert] = "更新に失敗しました。"
      render :edit
    end
  end

  def unsubscribe
  end

  def withdraw
    # user_check(guest)
    if @user.email == 'guest@example.com'
      # 2023/12/25追加（フラッシュメッセージ）
      flash.now[:alert] = "ゲストユーザーは退会できません。"
      render :unsubscribe
    else
      @user.update(is_deleted: true) # 退会フラグを「退会する」に更新（ログインユーザー）
      reset_session # 全てのsession（ログインユーザーの情報）を破棄する
      redirect_to root_path
    end
  end

  private

  def set_current_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :name_kana, :nickname, :postal_code, :address, :sex, :telephone_number, :email)
  end

end
