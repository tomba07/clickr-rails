class MakeBenchmarkOptionalInLessons < ActiveRecord::Migration[6.0]
  def change
    change_column_default :lessons, :benchmark, from: 1.0, to: nil
    change_column_null :lessons, :benchmark, true
  end
end
