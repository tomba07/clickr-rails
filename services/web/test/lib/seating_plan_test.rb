require 'test_helper'

class SeatingPlanTest < ActiveSupport::TestCase
  def setup
    coordinates = [[0, 0], [2, 1]]
    @students = coordinates.map { |row, col| create(:student, seat_row: row, seat_col: col) }
    school_class = create(:school_class)
    school_class.students = @students
    @subject = SeatingPlan.new(school_class)
  end
  test 'coordinates without border are correct' do
    assert_equal [
      [0, 0], [0, 1],
      [1, 0], [1, 1],
      [2, 0], [2, 1]
    ], @subject.coordinates(border: 0)
  end

  test 'coordinates with border are correct' do
    assert_equal [
      [-1, -1], [-1, 0], [-1, 1], [-1, 2],
      [ 0, -1], [ 0, 0], [ 0, 1], [ 0, 2],
      [ 1, -1], [ 1, 0], [ 1, 1], [ 1, 2],
      [ 2, -1], [ 2, 0], [ 2, 1], [ 2, 2],
      [ 3, -1], [ 3, 0], [ 3, 1], [ 3, 2],
    ], @subject.coordinates(border: 1)
  end

  test 'can get students and empty seat by row/col' do
    assert_nil @subject.student(row: 3, col: 3)
    assert_equal @students[0], @subject.student(row: 0, col: 0)
    assert_equal @students[1], @subject.student(row: 2, col: 1)
  end
end
