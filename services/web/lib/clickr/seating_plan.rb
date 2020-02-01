class Clickr::SeatingPlan
  attr_reader :school_class, :row_min, :row_max, :col_min, :col_max

  def initialize(school_class)
    @school_class = school_class
    students = school_class.students
    @row_min, @row_max = students.map(&:seat_row).minmax.map { |i| i || 0 }
    @col_min, @col_max = students.map(&:seat_col).minmax.map { |i| i || 0 }
    @students_by_coordinates =
      students.reduce({}) do |tmp, s|
        tmp.merge({ seat_hash(s.seat_row, s.seat_col) => s })
      end
  end

  def coordinates(border: 0)
    rows = @row_min - border..@row_max + border
    cols = @col_min - border..@col_max + border
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
