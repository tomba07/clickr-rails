class SeatingPlan
  attr_reader :row_min, :row_max, :col_min, :col_max

  def initialize(students)
    @row_min, @row_max = students.map { |s| s.seat_row }.minmax.map { |i| i || 0 }
    @col_min, @col_max = students.map { |s| s.seat_col }.minmax.map { |i| i || 0 }
    @students_by_coordinates = students.reduce({}) { |tmp, s| tmp.merge({ seat_hash(s.seat_row, s.seat_col) => s }) }
  end

  def coordinates(border: 0)
    rows = @row_min - border .. @row_max + border
    cols = @col_min - border .. @col_max + border
    return rows.to_a.product(cols.to_a)
  end

  def student(row:, col:)
    @students_by_coordinates[seat_hash(row, col)]
  end

  private
  def seat_hash(row, col)
    { row: row, col: col }.freeze
  end
end
