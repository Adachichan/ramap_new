class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.integer :review_id, null: false               ## 口コミID
      t.string :poster,     null: false               ## コメント投稿者
      t.text :content,      null: false               ## コメント内容
      t.timestamps
    end
  end
end
