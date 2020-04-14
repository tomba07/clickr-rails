require 'rails_helper'

RSpec.describe Click do
  describe 'spam_count' do
    it 'returns 0 if no clicks present' do
      expect(Click.spam_count).to eq 0
    end

    it 'returns 0 if only one useful click is present' do
      create(:click, useful: true)
      expect(Click.spam_count).to eq 0
    end

    it 'returns 1 if only one useless click is present' do
      create(:click, useful: false)
      expect(Click.spam_count).to eq 1
    end

    it 'returns 0 for clicks [useless, useful] (old to new)' do
      create(:click, useful: false)
      create(:click, useful: true)
      expect(Click.spam_count).to eq 0
    end

    it 'returns 1 for clicks [useful, useless] (old to new)' do
      create(:click, useful: true)
      create(:click, useful: false)
      expect(Click.spam_count).to eq 1
    end

    it 'returns 3 for clicks [useless, useful, useless, useful, useless, useless, useless] (old to new)' do
      %i[useless useful useless useful useless useless useless].each do |state|
        create(:click, useful: state == :useful)
      end
      expect(Click.spam_count).to eq 3
    end
  end
end
