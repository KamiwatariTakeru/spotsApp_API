class DropTableName < ActiveRecord::Migration[6.0]
  def change
    drop_table :spots
    drop_table :users
  end
end
