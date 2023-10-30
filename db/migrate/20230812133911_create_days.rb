class CreateDays < ActiveRecord::Migration[6.1]
  def change
    create_table :days do |t|
      t.string :name  ## 曜日
      t.timestamps
    end
  end
end
