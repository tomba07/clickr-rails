class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.references :school_class, null: false, foreign_key: true, index: true
      t.references :lesson, null: false, foreign_key: true, index: true
      t.string :name, null: false

      t.timestamps
    end

    add_index :questions, :created_at, order: {created_at: :desc}
  end
end
