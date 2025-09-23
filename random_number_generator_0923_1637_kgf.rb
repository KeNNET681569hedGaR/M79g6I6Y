# 代码生成时间: 2025-09-23 16:37:26
# RandomNumberGenerator.rb
# This class generates random numbers using Ruby's SecureRandom library.
# It is designed to be used within the Hanami framework.

require 'securerandom'

class RandomNumberGenerator
  # Generates a random number within a given range.
  #
  # @param min [Integer] The minimum value in the range.
  # @param max [Integer] The maximum value in the range.
  # @return [Integer] A random number between min and max.
  # @raise [ArgumentError] If min or max is not an integer or if min is greater than max.
  def generate_random_number(min, max)
    # Check if min and max are integers
    raise ArgumentError, 'Both min and max must be integers' unless min.is_a?(Integer) && max.is_a?(Integer)

    # Check if min is less than or equal to max
    raise ArgumentError, 'Min must be less than or equal to max' if min > max

    # Generate and return a random number within the range
    SecureRandom.random_number(max - min + 1) + min
  end
end
