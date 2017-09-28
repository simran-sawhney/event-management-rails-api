class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.integer :duration
      t.text :description, null: false
      t.integer :start_date, limit: 6, null: false #eg: 20170921
      t.integer :is_started, limit: 1, default: 0
      t.integer :is_completed, limit: 1, default: 0
      t.integer :is_published, limit: 1, default: 0
      t.integer :is_deleted, limit: 1, default: 0
      t.decimal :latitude, null: false
      t.decimal :longitude, null: false
      t.integer :owner_id, null: false

      t.timestamps
    end
  end
end
