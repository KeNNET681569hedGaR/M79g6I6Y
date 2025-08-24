# 代码生成时间: 2025-08-25 04:35:23
# text_file_analyzer.rb
require 'hanami'

# Analyzes the contents of a text file for various metrics
class TextFileAnalyzer
  # Initializes the analyzer with a file path
  #
  # @param file_path [String] the path to the text file
  def initialize(file_path)
    @file_path = file_path
  end

  # Analyzes the file and returns a hash of metrics
  #
  # @return [Hash] a hash containing the file's metrics
  def analyze
    return {} unless File.exist?(@file_path)
    return {} unless File.readable?(@file_path)

    contents = File.read(@file_path)
    metrics = {}
    metrics[:word_count] = word_count(contents)
    metrics[:line_count] = line_count(contents)
    metrics[:character_count] = character_count(contents)
    metrics
  end

  private

  # Counts the number of words in the file
  #
  # @param contents [String] the contents of the file
  # @return [Integer] the number of words
  def word_count(contents)
    contents.scan(/\w+/).count
  end

  # Counts the number of lines in the file
  #
  # @param contents [String] the contents of the file
  # @return [Integer] the number of lines
  def line_count(contents)
    contents.lines.count
  end

  # Counts the number of characters in the file
  #
  # @param contents [String] the contents of the file
  # @return [Integer] the number of characters
  def character_count(contents)
    contents.length
  end
end

# Example usage:
if __FILE__ == $0
  analyzer = TextFileAnalyzer.new('example.txt')
  metrics = analyzer.analyze
  puts metrics
end