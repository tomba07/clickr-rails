require 'test_helper'

class CurrentSchoolClassTest < ActiveSupport::TestCase
  def setup
    @schoolClass1 = create(:school_class)
    @schoolClass2 = create(:school_class)
  end

  test 'Get returns nil if no current school class is set' do
    assert_nil CurrentSchoolClass.get
  end

  test 'Get returns value of most recent set' do
    CurrentSchoolClass.set @schoolClass1
    CurrentSchoolClass.set @schoolClass2

    assert_equal @schoolClass2, CurrentSchoolClass.get
  end

  test 'Only one record exists even after set is called several times' do
    CurrentSchoolClass.set @schoolClass1
    CurrentSchoolClass.set @schoolClass2
    CurrentSchoolClass.set @schoolClass2
    CurrentSchoolClass.set @schoolClass1

    assert_equal 1, CurrentSchoolClass.count
  end
end
