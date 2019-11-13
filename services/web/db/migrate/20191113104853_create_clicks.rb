class CreateClicks < ActiveRecord::Migration[6.0]
  def change
    create_table :clicks do |t|
      t.string :device_id, null: false, index: true
      t.string :device_type, null: false, index: true

      t.timestamps
    end

    add_index :clicks, :created_at, order: { created_at: :desc }
  end
end
