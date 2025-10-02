# 代码生成时间: 2025-10-02 21:10:47
# NumericalIntegrationCalculator is a Hanami controller that handles numerical integration calculations.
class NumericalIntegrationCalculator < Hanami::Controller
  # POST /calculate
  def create
    begin
      # Extract parameters from the request
      lower_limit = params[:lower_limit].to_f
      upper_limit = params[:upper_limit].to_f
      function = params[:function]
      num_intervals = params[:num_intervals].to_i

      # Perform basic validation
      raise Hanami::Controller::InvalidParams, 'Lower limit must be less than upper limit' if lower_limit >= upper_limit
      raise Hanami::Controller::InvalidParams, 'Number of intervals must be a positive integer' if num_intervals <= 0

      # Calculate the integration using the trapezoidal rule as an example
      result = trapezoidal_rule(lower_limit, upper_limit, num_intervals, function)

      # Return the result as a JSON response
      self.body = { integration_result: result }.to_json
    rescue Hanami::Controller::InvalidParams => e
      # Return error message as a JSON response
      self.body = { error: e.message }.to_json
    end
  end

  # Trapezoidal rule for numerical integration
  private
  def trapezoidal_rule(lower, upper, num_intervals, function)
    # Calculate the width of each interval
    h = (upper - lower) / num_intervals
    area = 0.0

    # Calculate the sum of the areas of the trapezoids
    num_intervals.times do |i|
      x1 = lower + i * h
      x2 = x1 + h
      area += (h / 2.0) * (evaluate_function(x1, function) + evaluate_function(x2, function))
    end

    area
  end

  # Evaluates the given function at a specific point
  def evaluate_function(x, function)
    # Here we assume the function is a string that can be evaluated using eval.
    # In a real application, you would want to have a safer and more robust way to evaluate functions.
    eval(function).call(x)
  end
end