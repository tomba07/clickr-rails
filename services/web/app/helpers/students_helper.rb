module StudentsHelper
  def seat_hash(row, col)
    { row: row, col: col }.freeze
  end
end
