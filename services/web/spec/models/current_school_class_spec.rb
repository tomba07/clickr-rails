require 'rails_helper'

RSpec.describe CurrentSchoolClass do
  let(:schoolClass1) { create(:school_class) }
  let(:schoolClass2) { create(:school_class) }

  describe 'get' do
    it 'returns nil if no current school class is set' do
      assert_nil CurrentSchoolClass.get
    end

    it 'returns value of most recent set' do
      CurrentSchoolClass.set schoolClass1
      CurrentSchoolClass.set schoolClass2

      expect(CurrentSchoolClass.get).to eq schoolClass2
    end
  end

  describe 'set' do
    it 'only creates one record' do
      CurrentSchoolClass.set schoolClass1
      CurrentSchoolClass.set schoolClass2
      CurrentSchoolClass.set schoolClass2
      CurrentSchoolClass.set schoolClass1

      expect(CurrentSchoolClass.count).to eq 1
    end
  end
end
