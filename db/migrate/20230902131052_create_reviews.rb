class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.integer :user_id,  null: false               ## 会員ID
      t.integer :store_id, null: false               ## 店舗ID
      t.string :name,      null: false               ## 名前
      t.string :nickname,  null: false               ## ニックネーム
      t.date :visit_date,  null: false               ## 訪問日
      t.string :title,     null: false, default: ""  ## タイトル
      t.text :content,     null: false               ## 内容
      t.integer :score,    null: false               ## 口コミ評価（点数）
      t.timestamps
    end
  end
end
