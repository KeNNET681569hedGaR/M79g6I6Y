# 代码生成时间: 2025-08-31 05:56:48
# hash_calculator.rb
# This program is a hash calculator tool using Ruby and Hanami framework.
# It calculates the hash value of a given string using a specified algorithm.

require 'digest'
require 'hanami'

module HashCalculator
  # This class represents the hash calculator tool.
  class Tool
    # Calculate the hash value of a given string using a specified algorithm.
    #
    # @param string [String] The input string to calculate the hash for.
    # @param algorithm [String] The hashing algorithm to use (e.g., 'sha256', 'md5').
    # @return [String] The calculated hash value.
    # @raise [ArgumentError] If the algorithm is not supported.
    def calculate_hash(string, algorithm = 'sha256')
      unless Digest::Digest.respond_to?(algorithm)
        raise ArgumentError, "Unsupported algorithm: #{algorithm}"
      end

      # Use Digest module to calculate the hash value.
      hash_value = Digest::Digest.send(algorithm, string).hexdigest

      # Return the calculated hash value.
      hash_value
    end
  end
end

# Usage example:
# hash_calculator = HashCalculator::Tool.new
# puts hash_calculator.calculate_hash('Hello, World!') # Output: The SHA-256 hash of 'Hello, World!'
# puts hash_calculator.calculate_hash('Hello, World!', 'md5') # Output: The MD5 hash of 'Hello, World!'
