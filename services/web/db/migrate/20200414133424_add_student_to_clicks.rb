class AddStudentToClicks < ActiveRecord::Migration[6.0]
  def change
    add_reference :clicks, :student, null: true, foreign_key: true
  end
end
