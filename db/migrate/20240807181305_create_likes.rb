class CreateLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :likes do |t|
      t.bigint :user_id, null: false
      t.bigint :spot_id, null: false
      t.timestamps
    end

    add_index :likes, :user_id
    add_index :likes, :spot_id
    add_foreign_key :likes, :users
    add_foreign_key :likes, :spots
  end
end
