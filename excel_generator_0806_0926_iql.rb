# 代码生成时间: 2025-08-06 09:26:10
# ExcelGenerator is a Hanami service that generates Excel files.
class ExcelGenerator < Hanami::Entity
  include Hanami::Helpers::TagHelper

  # Generate an Excel file with the given data
  #
  # @param data [Array<Array>] 2D array representing the rows and columns of the Excel sheet
  # @param filename [String] The desired filename for the Excel file
  # @return [String] The path to the generated Excel file
  def self.generate_excel(data, filename)
    # Error handling for empty data
    raise ArgumentError, 'Data cannot be empty' if data.empty?

    # Create a new Excel file
    excel_file = Roo::Spreadsheet.open('template.xls')
    excel_file.create('Sheet1')
    sheet = excel_file.sheet('Sheet1')

    # Fill the Excel sheet with data
    data.each_with_index do |row, index|
      sheet.add_row(row, index)
    end

    # Save the Excel file with the given filename
    excel_file.save_as(::File.join(Hanami.root, 'tmp', filename))
    excel_file.close

    # Return the path to the generated Excel file
    ::File.join(Hanami.root, 'tmp', filename)
  end

  # Private: Validate the data format
  #
  # @param data [Array<Array>] The data to be validated
  # @return [Boolean] Whether the data is valid or not
  private_class_method
  def self.validate_data_format(data)
    data.all? { |row| row.is_a?(Array) } && data.none? { |row| row.empty? }
  end
end

# Usage example
# Assuming 'data' is a 2D array representing the rows and columns of the Excel sheet
# data = [["Header1", "Header2"], ["Row1", "Value1"], ["Row2", "Value2"]]
# ExcelGenerator.generate_excel(data, 'example.xlsx')
