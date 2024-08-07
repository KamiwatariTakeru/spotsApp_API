class CreateAuthInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :auth_infos, id: :string do |t|
      t.string :provider
      t.bigint :user_id, null: false
      t.timestamps
    end

    add_index :auth_infos, :user_id
    add_foreign_key :auth_infos, :users
  end
end
