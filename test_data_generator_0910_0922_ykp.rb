# 代码生成时间: 2025-09-10 09:22:40
# Test Data Generator using Hanami framework
#
# This program generates test data.

require 'hanami'
require 'faker'

# Test data generator service
class TestDataGenerator
  # Generate random user data
  #
  # @return [Hash] User data hash
  def generate_user
    # Error handling and logging
    begin
      user_data = {
        id: SecureRandom.uuid,
        name: Faker::Name.name,
        email: Faker::Internet.email,
        age: rand(18..65)
      }
      user_data
    rescue => e
      # Log error
      puts "Error generating user data: #{e.message}"
      nil
    end
  end

  # Generate random product data
  #
  # @return [Hash] Product data hash
  def generate_product
    # Error handling and logging
    begin
      product_data = {
        id: SecureRandom.uuid,
        name: Faker::Commerce.product_name,
        price: Faker::Commerce.price,
        category: Faker::Commerce.department
      }
      product_data
    rescue => e
      # Log error
      puts "Error generating product data: #{e.message}"
      nil
    end
  end
end

# Usage example
generator = TestDataGenerator.new
user_data = generator.generate_user
puts "Generated user data: #{user_data}"

product_data = generator.generate_product
puts "Generated product data: #{product_data}"
