class ButtonsController < ApplicationController
  def index
    @coordinates =
      ((1..9).to_a.product (1..4).to_a).map do |x, y|
        { x: x, y: y, empty: x == 5 }
      end
  end
end
