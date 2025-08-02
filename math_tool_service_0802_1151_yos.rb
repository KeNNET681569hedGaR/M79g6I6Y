# 代码生成时间: 2025-08-02 11:51:53
# math_tool_service.rb
# This service provides a set of mathematical operations.

require 'hanami'
require 'hanami/controller'

# Define the MathToolService class which inherits from Hanami::Controller
class MathToolService < Hanami::Controller
  # Add a route to handle GET requests for calculating the sum of two numbers
  get '/math/add', as: :addition do
    # Extract the parameters from the query string
    param :a, type: Integer, desc: 'The first operand'
    param :b, type: Integer, desc: 'The second operand'

    # Define the action to perform the addition and return the result
    def call(params)
      # Check for nil or non-integer values and return an error message
      if params[:a].nil? || params[:b].nil? || !params[:a].is_a?(Integer) || !params[:b].is_a?(Integer)
        halt 400, error_response("Invalid parameters. Both 'a' and 'b' must be integers.")
      end

      # Perform the addition and return the result
      result = params[:a] + params[:b]
      { sum: result }.to_json
    end
  end

  private

  # Helper method to create an error response in JSON format
  def error_response(message)
    {"error": message}.to_json
  end
end

# Add a route to handle GET requests for calculating the difference of two numbers
class MathToolService < Hanami::Controller
  get '/math/subtract', as: :subtraction do
    param :a, type: Integer, desc: 'The first operand'
    param :b, type: Integer, desc: 'The second operand'

    def call(params)
      if params[:a].nil? || params[:b].nil? || !params[:a].is_a?(Integer) || !params[:b].is_a?(Integer)
        halt 400, error_response("Invalid parameters. Both 'a' and 'b' must be integers.")
      end

      result = params[:a] - params[:b]
      { difference: result }.to_json
    end
  end
end

# Add a route to handle GET requests for calculating the product of two numbers
class MathToolService < Hanami::Controller
  get '/math/multiply', as: :multiplication do
    param :a, type: Integer, desc: 'The first operand'
    param :b, type: Integer, desc: 'The second operand'

    def call(params)
      if params[:a].nil? || params[:b].nil? || !params[:a].is_a?(Integer) || !params[:b].is_a?(Integer)
        halt 400, error_response("Invalid parameters. Both 'a' and 'b' must be integers.")
      end

      result = params[:a] * params[:b]
      { product: result }.to_json
    end
  end
end

# Add a route to handle GET requests for calculating the division of two numbers
class MathToolService < Hanami::Controller
  get '/math/divide', as: :division do
    param :a, type: Integer, desc: 'The first operand'
    param :b, type: Integer, desc: 'The second operand'

    def call(params)
      if params[:a].nil? || params[:b].nil? || !params[:a].is_a?(Integer) || !params[:b].is_a?(Integer)
        halt 400, error_response("Invalid parameters. Both 'a' and 'b' must be integers.")
      elsif params[:b] == 0
        halt 400, error_response("Invalid parameters. Division by zero is not allowed.")
      end

      result = params[:a].to_f / params[:b]
      { quotient: result }.to_json
    end
  end
end
