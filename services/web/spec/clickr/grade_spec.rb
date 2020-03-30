# TODO require only spec_helper (problems with loading lib/ modules)
require 'rails_helper'

RSpec.describe Clickr::Grade do
  describe 'GRADING_TABLE' do
    [
      [100, '1+'],
      [98, '1+'],
      [97, '1'],
      [95, '1'],
      [92, '1-'],
      [78, '2-'],
      [37, '5'],
      [25, '5-'],
      [0, '6']
    ].each do |percent, grade|
      it "maps #{percent}% to #{grade}" do
        expect(Clickr::Grade::GRADING_TABLE[percent]).to eq grade
      end
    end
  end

  describe 'from_percentage' do
    it 'converts 0.77 to 2-' do
      expect(Clickr::Grade.from_percentage(0.77)).to eq '2-'
    end
  end
end
