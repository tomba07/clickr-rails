module NumberHelper
  def percentage(p)
    number_to_percentage(100.0 * p, precision: 0)
  end
end
