class CreateEvaluations < ActiveRecord::Migration[6.0]
  def change
    create_table :evaluations do |t|
      t.bigint :user_id, null: false
      t.bigint :spot_id, null: false
      t.integer :starsAmount
      t.timestamps
    end

    add_index :evaluations, :user_id
    add_index :evaluations, :spot_id
    add_foreign_key :evaluations, :users
    add_foreign_key :evaluations, :spots
  end
end
