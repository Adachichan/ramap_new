class CreateRegularHolidays < ActiveRecord::Migration[6.1]
  def change
    create_table :regular_holidays do |t|
      t.integer :store_id, null: false  ## 店舗ID
      t.integer :day_id,   null: false  ## 曜日ID
      t.timestamps
    end
  end
end
