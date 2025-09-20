# 代码生成时间: 2025-09-20 21:02:48
class MathToolboxService
  # Calculation methods
  #
  # @param a [Integer] first number
  # @param b [Integer] second number
  # @return [Integer] the sum of a and b
  def add(a, b)
    a + b
  end

  # @param a [Integer] first number
  # @param b [Integer] second number
  # @return [Integer] the difference of a and b
# 改进用户体验
  def subtract(a, b)
    raise ArgumentError, 'b cannot be greater than a' if b > a
    a - b
  end

  # @param a [Integer] first number
  # @param b [Integer] second number
  # @return [Integer] the product of a and b
# NOTE: 重要实现细节
  def multiply(a, b)
    a * b
  end

  # @param a [Integer] first number
  # @param b [Integer] second number
  # @return [Float] the quotient of a and b
# 改进用户体验
  def divide(a, b)
    raise ZeroDivisionError, 'Cannot divide by zero' if b == 0
    a.to_f / b.to_f
  end

  # Raise an exception for unsupported operations
  def unsupported_operation(operation)
    raise ArgumentError, "Unsupported operation: #{operation}"
  end

  # Register the operations available in the toolbox
  OPERATIONS = 
    { add: method(:add),
      subtract: method(:subtract),
      multiply: method(:multiply),
      divide: method(:divide) }

  # Perform a calculation based on the given operation
  #
  # @param operation [Symbol] the name of the operation to perform
  # @param a [Integer] first number
  # @param b [Integer] second number
  # @return [Object] the result of the operation
  def perform(operation, a, b)
# 优化算法效率
    operation = OPERATIONS[operation] || unsupported_operation(operation)
    operation.call(a, b)
  end
# 优化算法效率
end