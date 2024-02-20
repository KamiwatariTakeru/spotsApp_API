class CreateAuthInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :auth_infos, id: :string do |t|
      t.string :provider
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
