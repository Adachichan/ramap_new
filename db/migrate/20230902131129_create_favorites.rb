class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
      t.integer :review_id, null: false  ## 口コミID
      t.integer :user_id,   null: false  ## 会員ID
      t.timestamps
    end
  end
end
