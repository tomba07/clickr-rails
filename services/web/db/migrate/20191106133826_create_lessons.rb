class CreateLessons < ActiveRecord::Migration[6.0]
  def change
    create_table :lessons do |t|
      t.text :title
      t.references :school_class, null: false, foreign_key: true

      t.timestamps
    end
  end
end
