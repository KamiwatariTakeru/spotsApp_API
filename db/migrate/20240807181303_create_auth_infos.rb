class CreateAuthInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :auth_infos do |t|
      t.string :provider
      t.references :user, null: false, foreign_key: true
    end
  end
end
