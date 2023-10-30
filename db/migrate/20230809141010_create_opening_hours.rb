class CreateOpeningHours < ActiveRecord::Migration[6.1]
  def change
    create_table :opening_hours do |t|
      t.references :store, foreign_key: true  ## 店舗ID
      t.time :opening_time, null: false       ## 営業開始時間
      t.time :closing_time, null: false       ## 営業終了時間
      t.timestamps
    end
  end
end
