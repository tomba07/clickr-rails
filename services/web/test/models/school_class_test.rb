require 'test_helper'

class SchoolClassTest < ActiveSupport::TestCase
  def setup
    @subject = create(:school_class)
    @long_ago = Rails.application.config.clickr.suggest_new_lesson_after_minutes.minutes.ago - 1.minute
  end

  test 'suggest_creating_new_lesson is false if no lesson existed (new one was created)' do
    assert_equal false, @subject.suggest_creating_new_lesson?
  end

  test 'suggest_creating_new_lesson is false if a new lesson exists' do
    @subject.lessons.create!(name: 'lesson', created_at: 1.minute.ago)
    assert_equal false, @subject.suggest_creating_new_lesson?
  end

  test 'suggest_creating_new_lesson is true if no questions existed for an old lesson' do
    @subject.lessons.create!(name: 'lesson', created_at: @long_ago)
    assert_equal true, @subject.suggest_creating_new_lesson?
  end

  test 'suggest_creating_new_lesson is true if an old question existed for an old lesson' do
    lesson = @subject.lessons.create!(name: 'lesson', created_at: @long_ago)
    lesson.questions.create!(name: 'question', created_at: @long_ago, school_class: @subject)
    assert_equal true, @subject.suggest_creating_new_lesson?
  end

  test 'suggest_creating_new_lesson is false if an new question exists for an old lesson' do
    lesson = @subject.lessons.create!(name: 'lesson', created_at: @long_ago)
    lesson.questions.create!(name: 'question', created_at: 1.minute.ago, school_class: @subject)
    assert_equal false, @subject.suggest_creating_new_lesson?
  end

  test 'floor_plan works if minimumm size is exceeded' do
    s1, s2, s3, s4 = @subject.students.create! [
      { name: '1', seat_row: 0, seat_col: 0 },
      { name: '2', seat_row: 4, seat_col: 1 },
      { name: '3', seat_row: 0, seat_col: 4 },
      { name: '4', seat_row: 2, seat_col: 0 }
   ]
    assert_equal [
      [s1,  nil, nil, nil, s3 ],
      [nil, nil, nil, nil, nil],
      [s4,  nil, nil, nil, nil],
      [nil, nil, nil, nil, nil],
      [nil, s2,  nil, nil, nil]
    ], @subject.floor_plan
  end

  test 'floor_plan has minimum size if there are no students' do
    config = Rails.application.config.clickr
    assert_equal Array.new(config.min_seat_rows) { Array.new(config.min_seat_cols) }, @subject.floor_plan
  end
end
