class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :line_id, null: false
      t.string :latitude, null: false
      t.string :longitude, null: false

      t.timestamps
    end
  end
end
