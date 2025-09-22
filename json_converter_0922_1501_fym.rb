# 代码生成时间: 2025-09-22 15:01:30
# JSON Data Formatter using Ruby and Hanami Framework
#
# This program is designed to convert JSON data formats.
# It includes error handling, documentation, and follows Ruby best practices.

require 'hanami'
require 'json'
require 'hanami/helpers'
require 'hanami/validations'
require 'hanami/validations/formatters/json_formatter'

# Define a service to handle JSON data conversion
class JsonConverter
  include Hanami::Helpers
  include Hanami::Validations::Formatters::JsonFormatter

  # Validates and converts the JSON data
  #
  # @param [String] json_data The JSON string to be converted
  # @return [Hash] The converted JSON data in Ruby Hash format
  def convert(json_data)
    if valid_json?(json_data)
      JSON.parse(json_data)
    else
      raise 'Invalid JSON data provided'
    end
  end

  # Checks if the provided data is a valid JSON
  #
  # @param [String] data The data to be checked
  # @return [Boolean] true if valid JSON, false otherwise
  def valid_json?(data)
    begin
      JSON.parse(data) rescue false
    rescue JSON::ParserError
      false
    end
  end
end

# Example usage of the JsonConverter service
if __FILE__ == $0
  converter = JsonConverter.new
  json_data = '{"name":"John", "age":30}'
  begin
    data = converter.convert(json_data)
    puts "Converted data: #{data}"
  rescue => e
    puts "Error: #{e.message}"
  end
end