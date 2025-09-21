# 代码生成时间: 2025-09-21 15:09:41
# excel_generator.rb
# This script generates an Excel file using Ruby and the Hanami framework.

require 'hanami'
require 'roo'
require 'roo-xls'

# Define a class to handle Excel generation
class ExcelGenerator
  # Initialize with the path to the Excel file
  def initialize(file_path)
    @file_path = file_path
  end

  # Generate an Excel file with given data
  def generate(data)
    begin
      # Check if the data is an array of arrays
      raise ArgumentError, 'Data must be an array of arrays' unless data.is_a?(Array) && data.all? { |row| row.is_a?(Array) }

      # Create a new Excel spreadsheet
      spreadsheet = Roo::Spreadsheet.new(@file_path)
      worksheet = spreadsheet.add_worksheet('Sheet 1')

      # Iterate over the data and add it to the worksheet
      data.each_with_index do |row, index|
        worksheet.add_row(row, index)
      end

      # Save the Excel file
      spreadsheet.save
      puts 'Excel file generated successfully.'
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
    end
  end
end

# Example usage
if __FILE__ == $PROGRAM_NAME
  # Define the path to the Excel file
  file_path = './example.xlsx'
  # Define the data to be written to the Excel file
  data = [
    ['Name', 'Age', 'City'],
    ['John Doe', 30, 'New York'],
    ['Jane Smith', 25, 'Los Angeles']
  ]

  # Create an instance of the ExcelGenerator and generate the file
  generator = ExcelGenerator.new(file_path)
  generator.generate(data)
end