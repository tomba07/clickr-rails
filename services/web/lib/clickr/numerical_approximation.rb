# Newton's method freestyle (not bullet-proof, but good enough)
class Clickr::NumericalApproximation
  attr_reader :result, :y_delta, :n_iterations

  def initialize(
    function:,
    x_min:,
    x_max:,
    y_target:,
    anchor_y_delta: 0.01,
    anchor_n_iterations: 10
  )
    @function = function
    @x_min = x_min
    @x_max = x_max
    @y_target = y_target
    @anchor_y_delta = anchor_y_delta
    @anchor_n_iterations = anchor_n_iterations
    @n_iterations = 0
    @result = approximate(@x_min, @x_max, @anchor_n_iterations)
    @y_delta = (@function.call(@result) - y_target).abs
  end

  private

  def approximate(x_min, x_max, n)
    return x_min if x_min == x_max

    @n_iterations += 1

    y_min = @function.call x_min
    y_max = @function.call x_max
    slope = (y_max - y_min) / (x_max - x_min)
    # assume linear fit
    x_new = x_min + (@y_target - y_min) / slope
    y_new = @function.call x_new
    y_delta = (y_new - @y_target).abs

    return x_new if y_delta < @anchor_y_delta || n <= 0

    x_min_new, x_max_new = y_new < @y_target ? [x_min, x_new] : [x_new, x_max]
    return approximate(x_min_new, x_max_new, n - 1)
  end
end
