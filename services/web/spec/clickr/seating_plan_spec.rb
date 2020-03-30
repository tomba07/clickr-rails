require 'rails_helper'

RSpec.describe Clickr::SeatingPlan do
  let(:coordinates) { [[0, 0], [2, 1]] }
  let(:students) do
    coordinates.map do |row, col|
      create(:student, seat_row: row, seat_col: col)
    end
  end
  let(:school_class) { create(:school_class, students: students) }
  subject { Clickr::SeatingPlan.new(school_class) }

  describe 'coordinates' do
    it 'has no border for border = 0' do
      expect(subject.coordinates(border: 0)).to eq [
           [0, 0],
           [0, 1],
           [1, 0],
           [1, 1],
           [2, 0],
           [2, 1]
         ]
    end

    it 'includes border for border = 1' do
      expect(subject.coordinates(border: 1)).to eq [
           [-1, -1],
           [-1, 0],
           [-1, 1],
           [-1, 2],
           [0, -1],
           [0, 0],
           [0, 1],
           [0, 2],
           [1, -1],
           [1, 0],
           [1, 1],
           [1, 2],
           [2, -1],
           [2, 0],
           [2, 1],
           [2, 2],
           [3, -1],
           [3, 0],
           [3, 1],
           [3, 2]
         ]
    end
  end

  describe 'student' do
    it 'gets empty seat by row/col' do
      expect(subject.student(row: 3, col: 3)).to be_nil
    end

    it 'gets students by row/col' do
      expect(subject.student(row: 0, col: 0)).to eq students[0]
      expect(subject.student(row: 2, col: 1)).to eq students[1]
    end
  end
end
