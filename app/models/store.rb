class Store < ApplicationRecord

  has_many :menus, dependent: :destroy
  has_many :opening_hours, dependent: :destroy
  has_many :regular_holidays, dependent: :destroy
  has_many :days, through: :regular_holidays
  has_many :reviews
  belongs_to :user
  belongs_to :store_genre
  has_one_attached :store_image

  accepts_nested_attributes_for :opening_hours, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true
  validates :name_kana, presence: true
  validates :postal_code, presence: true, format: { with: /\A\d{7}\z/ } # 7桁の半角数字
  validates :prefecture, presence: true
  validates :address, presence: true
  validates :telephone_number, presence: true, format: { with: /\A\d{10,11}\z/ } # 半角数字ハイフンなしで10桁or11桁
  validates :lowest_price_range, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0} # 整数かつ ”0” 以上
  validates :highest_price_range, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0} # 整数かつ ”0” 以上
  validates :representative, presence: true
  validates :representative_kana, presence: true
  validates :representative_email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :staff, presence: true
  validates :staff_telephone_number, presence: true, format: { with: /\A\d{10,11}\z/ } # 半角数字ハイフンなしで10桁or11桁
  validates :staff_email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  # full_addressが更新されたときにgeocoding
  geocoded_by :full_address
  after_validation :geocode

  # prefecture、address、building_and_apartmentを結合
  def full_address
    [self.prefecture_i18n, self.address, self.building_and_apartment].compact.join()
  end

  enum prefecture: { none_prefecture: 0, hokkaido: 1, aomori: 2, iwate: 3, miyagi: 4, akita: 5, yamagata: 6, fukushima: 7,
  ibaraki: 8, tochigi: 9, gunma: 10, saitama: 11, chiba: 12, tokyo: 13, kanagawa: 14, #/
  niigata: 15, toyama: 16, ishikawa: 17, fukui: 18, yamanashi: 19, nagano: 20, #/
  gifu: 21, shizuoka: 22, aichi: 23, mie: 24, #/
  shiga: 25, kyoto: 26, osaka: 27, hyogo: 28, nara: 29, wakayama:30, #/
  tottori: 31, shimane: 32, okayama: 33, hiroshima: 34, yamaguchi: 35, #/
  tokushima: 36, kagawa: 37, ehime: 38, kochi: 39, #/
  fukuoka: 40, saga: 41, nagasaki: 42, kumamoto: 43, oita: 44, miyazaki: 45, kagoshima: 46, okinawa: 47}

  # 店舗画像に関する実装
  # 画像の中身が空であるか判別
  def get_store_image(size)
    unless store_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      store_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpeg')
    end

    # 画像のサイズ調整
    if !size.empty?
      store_image.variant(resize: size).processed
    else
      store_image
    end
  end

  # パラメータを指定して検索を実行する
  def self.search_for(search_store_params)

    # 閉店した店舗は取り出し対象外
    search_stores = self.where(is_closed: false)

    # 店舗名の検索（検索方法の分岐）
    if search_store_params[:store_name].present?
      # 完全一致
      if search_store_params[:search_method] == "perfect_match"
        search_stores = search_stores.where("name LIKE ?", "#{search_store_params[:store_name]}")
      # 前方一致
      elsif search_store_params[:search_method] == "forward_match"
        search_stores = search_stores.where("name LIKE ?", "#{search_store_params[:store_name]}%")
      # 後方一致
      elsif search_store_params[:search_method] == "backward_match"
        search_stores = search_stores.where("name LIKE ?", "%#{search_store_params[:store_name]}")
      # 部分一致
      else
        search_stores = search_stores.where("name LIKE ?", "%#{search_store_params[:store_name]}%")
      end
    end

    # 都道府県の完全一致
    unless search_store_params[:prefecture] == "none_prefecture"
      search_stores = search_stores.where(prefecture: search_store_params[:prefecture])
    end

    # 予算が価格帯の中に入っているか確認
    if search_store_params[:budget].present?
      search_stores = search_stores.where(lowest_price_range: ..search_store_params[:budget].to_i, highest_price_range: search_store_params[:budget].to_i..)
    end

    # 時間検索
    if search_store_params[:visit_time].present?

      # 時間変換（0:00を基準とした分）
      visit_time_min = Time.parse(search_store_params[:visit_time]).strftime("%H").to_i * 60 + Time.parse(search_store_params[:visit_time]).strftime("%M").to_i

      # 空配列の作成（開店店舗のid保存用）
      opening_store_ids = []

      # 店舗ごとの時間比較（0:00を基準とした分）
      search_stores.each do |search_store|

        search_store.opening_hours.each do |opening_hour|
          opening_time_min = opening_hour.opening_time.strftime("%H").to_i * 60 + opening_hour.opening_time.strftime("%M").to_i
          closing_time_min = opening_hour.closing_time.strftime("%H").to_i * 60 + opening_hour.closing_time.strftime("%M").to_i

          # 開店時間の時刻が閉店時間の時刻より早い場合（日を跨いでいない場合）
          if opening_time_min <= closing_time_min
            if (opening_time_min <= visit_time_min) && (visit_time_min <= closing_time_min)
              opening_store_ids.push(search_store.id)
            end
          # 閉店時間の時刻が開店時間の時刻より早い場合（日を跨いでいる場合）
          else
            if ((opening_time_min <= visit_time_min) && (visit_time_min <= 1439)) || ((0 <= visit_time_min) && (visit_time_min <= closing_time_min))
              opening_store_ids.push(search_store.id)
            end
          end

        end
      end
      # 営業時間を考慮した店舗の絞り込み
      search_stores = search_stores.where(id: opening_store_ids)

    end

    # 選択した曜日が定休日である店舗を削除
    if search_store_params[:visit_day_id].present?
      holiday_store_ids = RegularHoliday.where(day_id: search_store_params[:visit_day_id].to_i).pluck(:store_id)
      search_store_ids = search_stores.pluck(:id)
      search_stores = Store.where(id: (search_store_ids - holiday_store_ids))
    end

    search_stores

  end

end
