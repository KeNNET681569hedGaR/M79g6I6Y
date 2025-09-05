# 代码生成时间: 2025-09-05 16:42:54
# json_converter.rb
# This is a simple JSON data format converter using Ruby and Hanami framework.

require 'hanami'
def json_converter(input_data)
  # Define the data structures for conversion
  conversions = {
    'camel_case' => ->(data) { camel_case(data) },
    'snake_case' => ->(data) { snake_case(data) },
  }

  # Check if the conversion type is provided and valid
  unless conversions.include?(input_data['type'])
    raise ArgumentError, 'Invalid conversion type'
  end

  # Perform the conversion using the provided type
  conversion_result = conversions[input_data['type']].call(input_data['data'])

  return {
    'status' => 'success',
    'result' => conversion_result
  }
rescue ArgumentError => e
  {
    'status' => 'error',
    'message' => e.message
  }
rescue => e
  {
    'status' => 'error',
    'message' => "An unexpected error occurred: #{e.message}"
  }
end
def camel_case(data)
  # Convert a hash from snake_case to camelCase
  # Example: {'field_name' => 'value'} to {'fieldName' => 'value'}
  case data
  when Hash
    Hash[data.map { |k, v| [camel_case(k), camel_case(v)] }]
  when Array
    data.map { |item| camel_case(item) }
  else
    data
  end
end
def snake_case(data)
  # Convert a hash from camelCase to snake_case
  # Example: {'fieldName' => 'value'} to {'field_name' => 'value'}
  require 'strscan'
  strscan = StringScanner.new(data.to_s)
  snake_case_key = ""
  while (token = strscan.scan(/_?[A-Za-z0-9]+/)) do
    token = token.gsub(/([A-Z])/, '_\1')
    snake_case_key << token.downcase
  end
  snake_case_key
end

# Example usage
input_data = {
  'type' => 'camel_case',
  'data' => {'first_name' => 'John', 'last_name' => 'Doe'}
}

puts JSON.pretty_generate(json_converter(input_data))
