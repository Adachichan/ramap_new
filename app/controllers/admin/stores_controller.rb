class Admin::StoresController < ApplicationController

  before_action :authenticate_admin!
  before_action :identify_store, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def update
    # 店舗情報の更新可否
    if @store.update(store_params)
      redirect_to admin_store_path(@store.id)
    else
      render :edit
    end
  end

  private

  def store_params
    # opening_hours_attributesが子のモデルに保存する要素
    # :id、:_destroyをつけることで、編集および削除が可能になる
    params.require(:store).permit(
      :name, :name_kana, :postal_code, :prefecture, :address, :building_and_apartment,
      :telephone_number, :fax_number, :store_image, :store_genre_id, :lowest_price_range,
      :highest_price_range, :closest_station,:representative, :representative_kana,
      :representative_email, :is_closed, :note, :staff, :staff_telephone_number, :staff_email, :latitude, :longitude,
      day_ids: [],
      opening_hours_attributes: [:id, :opening_time, :closing_time, :_destroy])
  end

  def identify_store
    @store = Store.find(params[:id])
  end

end
