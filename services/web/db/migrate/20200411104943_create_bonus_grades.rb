class CreateBonusGrades < ActiveRecord::Migration[6.0]
  def change
    create_table :bonus_grades do |t|
      t.references :student, null: false, foreign_key: true
      t.references :school_class, null: false, foreign_key: true
      t.float :percentage, null: false

      t.timestamps
    end
  end
end
