class AddScoreToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :score, :integer, null: false, default: 1
  end
end
