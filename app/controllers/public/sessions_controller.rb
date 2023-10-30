# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :user_state, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end

  protected

  # User_sign_in
  def after_sign_in_path_for(resource)
    root_path
  end

  # User_sign_out
  def after_sign_out_path_for(resource)
    root_path
  end

  # 退会しているかを判断するメソッド
  def user_state
    # 入力されたemailの存在判定
    @user = User.find_by(email: params[:user][:email])
    if @user
      # 取得したアカウントのパスワードと入力されたパスワードが一致しているか判別
      # 退会フラグがtrueの場合、サインアップ画面に遷移する
      if @user.valid_password?(params[:user][:password]) && @user.is_deleted == true
        redirect_to new_user_session_path
      end
    end
  end

end
