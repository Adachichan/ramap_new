class CreateMenus < ActiveRecord::Migration[6.1]
  def change
    create_table :menus do |t|
      t.integer :store_id, null: false               ## 店舗ID
      t.string :name,      null: false, default: ""  ## メニュー名
      t.integer :price,    null: false               ## 税抜価格
      t.timestamps
    end
  end
end
