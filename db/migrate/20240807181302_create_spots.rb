class CreateSpots < ActiveRecord::Migration[6.0]
  def change
    create_table :spots do |t|
      t.string :name
      t.string :address
      t.integer :stars_sum
      t.float :stars_avg
      t.float :latitude, limit: 53
      t.float :longitude, limit: 53
      t.timestamps
    end
  end
end
