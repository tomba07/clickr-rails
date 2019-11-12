class CreateStudents < ActiveRecord::Migration[6.0]
  def change
    create_table :students do |t|
      t.references :school_class, null: false, foreign_key: true
      t.string :name
      t.integer :seat_row
      t.integer :seat_col

      t.timestamps
    end
  end
end
