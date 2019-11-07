class AddLessonToQuestion < ActiveRecord::Migration[6.0]
  def change
    add_reference :questions, :lesson, null: false, foreign_key: true
  end
end
