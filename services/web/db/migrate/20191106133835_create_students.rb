class CreateStudents < ActiveRecord::Migration[6.0]
  def change
    create_table :students do |t|
      t.references :school_class, null: false, foreign_key: true, index: true
      t.string :name, null: false
      t.integer :seat_row, null: false
      t.integer :seat_col, null: false

      t.timestamps
    end

    add_index :students, %i[school_class name], unique: true
    add_index :students, %i[school_class seat_row seat_col], unique: true
  end
end
