class DropTableName < ActiveRecord::Migration[6.0]
  def change
    drop_table :auth_infos
  end
end
