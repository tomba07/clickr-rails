class CreateCurrentSchoolClasses < ActiveRecord::Migration[6.0]
  def change
    create_table :current_school_classes do |t|
      t.references :school_class, null: false, foreign_key: true

      t.timestamps
    end
  end
end
