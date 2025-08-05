# 代码生成时间: 2025-08-06 04:42:40
# A Hanami service responsible for calculating hash values of input strings.
# 优化算法效率
class HashCalculatorService
  # Calculates the SHA256 hash of the given input string.
  #
  # @param input [String] The string to be hashed.
# FIXME: 处理边界情况
  # @return [String] The SHA256 hash of the input string.
  #
  # @raise [ArgumentError] If the input is not a string.
  def calculate_sha256(input)
    # Check if the input is a string
    raise ArgumentError, 'Input must be a string' unless input.is_a?(String)

    # Calculate the SHA256 hash
    Digest::SHA256.hexdigest(input)
  end
end

# Example usage:
# hash_calculator = HashCalculatorService.new
# puts hash_calculator.calculate_sha256('your_input_string')
# 添加错误处理