require 'rails_helper'

RSpec.describe Clickr::NumericalApproximation do
  describe 'linear function' do
    let(:function) { ->(x) { x } }
    it 'solves it perfectly with one iteration (0.5 * 1 = 0.5)' do
      handle =
        described_class.new(
          function: function, x_min: 0, x_max: 1, y_target: 0.5
        )

      expect(handle.result).to eq 0.5
      expect(handle.y_delta).to eq 0
      expect(handle.n_iterations).to eq 1
    end
  end

  describe 'quadratic function' do
    let(:function) { ->(x) { x * x } }
    it 'solves it acceptably (0.5^2 = 0.25)' do
      handle =
        described_class.new(
          function: function,
          x_min: 0,
          x_max: 1,
          y_target: 0.25,
          anchor_y_delta: 0.1
        )

      expect(handle.result).to be_within(0.1).of 0.5
      expect(handle.y_delta).to be_within(0.1).of 0
    end
  end
end
