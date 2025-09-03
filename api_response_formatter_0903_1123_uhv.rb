# 代码生成时间: 2025-09-03 11:23:27
# ApiResponseFormatter is a utility class that formats API responses for consistency and error handling.
class ApiResponseFormatter
  # Format a successful API response
  #
  # @param data [Object] the data to be sent as the response body
  # @return [Hanami::View::Response] a formatted response
  def self.success(data)
    Hanami::View::Response.new(
      200,
      {
        'Content-Type' => 'application/json'
      },
      JSON.generate({
        status: 'success',
        data: data
      })
    )
  end

  # Format an error API response
  #
  # @param error [StandardError] the error that occurred
  # @return [Hanami::View::Response] a formatted error response
  def self.error(error)
    Hanami::View::Response.new(
      error.status || 500,
      {
        'Content-Type' => 'application/json'
      },
      JSON.generate({
        status: 'error',
        message: error.message
      })
    )
  end
end

# Example usage of the ApiResponseFormatter
if __FILE__ == $0
  begin
    # Simulate a successful API response
    response = ApiResponseFormatter.success({ key: 'value' })
    puts response.body

    # Simulate an error API response
    # response = ApiResponseFormatter.error(StandardError.new('Something went wrong'))
    # puts response.body
  rescue StandardError => e
    # Handle any unexpected errors
    puts ApiResponseFormatter.error(e).body
  end
end