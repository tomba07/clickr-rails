class ConvertBenchmarkToFloat < ActiveRecord::Migration[6.0]
  def change
    change_column :lessons, :benchmark, :float
  end
end
