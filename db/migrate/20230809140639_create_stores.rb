class CreateStores < ActiveRecord::Migration[6.1]
  def change
    create_table :stores do |t|
      t.integer :user_id,               null: false                  ## 会員ID
      t.integer :store_genre_id,        null: false                  ## 店舗ジャンルID
      t.string :name,                   null: false, default: ""     ## 店舗名
      t.string :name_kana,              null: false, default: ""     ## 店舗名（カナ）
      t.string :postal_code,            null: false, default: ""     ## 郵便番号
      t.integer :prefecture,            null: false, default: 0      ## 都道府県
      t.string :address,                null: false, default: ""     ## 住所
      t.string :building_and_apartment,              default: ""     ## ビル・マンション名
      t.string :telephone_number,       null: false, default: ""     ## 電話番号
      t.string :fax_number,                          default: ""     ## FAX番号
      t.integer :lowest_price_range,    null: false                  ## 最低金額（価格帯）※税抜
      t.integer :highest_price_range,   null: false                  ## 最高金額（価格帯）※税抜
      t.string :closest_station,                     default: ""     ## 最寄り駅
      t.string :representative,         null: false, default: ""     ## 代表者名
      t.string :representative_kana,    null: false, default: ""     ## 代表者名（カナ）
      t.string :representative_email,   null: false, default: ""     ## 代表者メールアドレス
      t.text :note                                                   ## 備考
      t.string :staff,                  null: false, default: ""     ## 担当者名
      t.string :staff_telephone_number, null: false, default: ""     ## 担当者の電話番号
      t.string :staff_email,            null: false, default: ""     ## 担当者メールアドレス
      t.float :latitude                                              ## 緯度
      t.float :longitude                                             ## 経度
      t.boolean :is_closed,                          default: false  ## 閉店フラグ
      t.timestamps
    end
  end
end
