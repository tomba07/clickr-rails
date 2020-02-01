class AddBenchmarkToLesson < ActiveRecord::Migration[6.0]
  def change
    add_column :lessons, :benchmark, :integer, default: 1, null: false
  end
end
