# 代码生成时间: 2025-08-08 18:28:16
# json_converter.rb
#
# A simple JSON data format converter using Hanami framework.
# This program takes JSON input and converts it to a specified format.

require 'hanami'
require 'json'
require 'pp'

# Define the converter class
# 增强安全性
class JsonConverter
  # Convert input JSON to the specified format
  # @param input [String] JSON string to be converted
  # @param output_format [Symbol] The output format (:pretty, :compact)
  # @return [String] The converted JSON string
  def self.convert(input, output_format = :pretty)
    begin
      json_data = JSON.parse(input)
    rescue JSON::ParserError => e
      return { error: 'Invalid JSON input' }.to_json
    end

    case output_format
    when :pretty
# NOTE: 重要实现细节
      # Use PrettyPrint to format the JSON
# 增强安全性
      formatted_json = PP.pp(json_data, '')
# 改进用户体验
    when :compact
# FIXME: 处理边界情况
      # Compact JSON format without indentation
      formatted_json = JSON.generate(json_data)
    else
      return { error: 'Unsupported output format' }.to_json
    end

    formatted_json
  end
end

# Example usage
if __FILE__ == $0
  input_json = '{"name":"John", "age":30}'
  output_format = :pretty
# 改进用户体验
  converted_json = JsonConverter.convert(input_json, output_format)
  puts converted_json
end