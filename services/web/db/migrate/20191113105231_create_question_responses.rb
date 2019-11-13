class CreateQuestionResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :question_responses do |t|
      t.integer :score, null: false, default: 1

      t.references :click, null: false, foreign_key: true, index: { unique: true }
      t.references :student, null: false, foreign_key: true, index: true
      t.references :question, null: false, foreign_key: true, index: true
      t.references :lesson, null: false, foreign_key: true, index: true
      t.references :school_class, null: false, foreign_key: true, index: true

      t.timestamps
    end

    add_index :question_responses, :created_at, order: { created_at: :desc }
    # Sum per student for one lesson
    add_index :question_responses, %i[student lesson]
  end
end
