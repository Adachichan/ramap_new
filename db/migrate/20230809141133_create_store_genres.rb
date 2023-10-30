class CreateStoreGenres < ActiveRecord::Migration[6.1]
  def change
    create_table :store_genres do |t|
      t.string :name, null: false, default: ""  ## 店舗ジャンル
      t.timestamps
    end
  end
end
