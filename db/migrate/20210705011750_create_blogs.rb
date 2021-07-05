class CreateBlogs < ActiveRecord::Migration[6.1]
  def change
    create_table :blogs do |t|
#ここから
      t.string :title
      t.text :content
      t.datetime :start_time
#ここまでを追加
      t.timestamps
    end
  end
end
