# 代码生成时间: 2025-09-06 12:47:13
# TextFileAnalyzer is a Hanami application that analyzes text file content
class TextFileAnalyzer < Hanami::Entity
  # Include Hanami::Helpers to use various helper methods
  include Hanami::Helpers

  # Analyze the content of a text file
  #
  # @param file_path [String] the path to the text file to analyze
  # @return [Hash] a hash containing analysis results
  def analyze(file_path)
    # Check if the file exists and is readable
    unless File.exist?(file_path) && File.readable?(file_path)
      raise ArgumentError.new("File does not exist or is not readable: #{file_path}")
    end

    # Read the file content
    content = File.read(file_path)

    # Perform analysis on the file content
    analysis_results = {
      word_count: content.split.length,
      lines_count: content.lines.count,
      characters_count: content.length,
      most_frequent_word: most_frequent_word(content)
    }

    analysis_results
  end

  private

  # Find the most frequent word in the content
  #
  # @param content [String] the content to analyze
  # @return [String] the most frequent word
  def most_frequent_word(content)
    # Split the content into words and count their occurrences
    words = content.scan(/\w+/)
    word_count = words.each_with_object(Hash.new(0)) { |word, count| count[word] += 1 }

    # Find the word with the highest count
    most_frequent = word_count.max_by { |_word, count| count }
    most_frequent.first if most_frequent
  end
end

# Usage example
if __FILE__ == $0
  analyzer = TextFileAnalyzer.new
  begin
    file_path = ARGV[0]
    results = analyzer.analyze(file_path)
    puts "Analysis Results: #{results}
"
  rescue ArgumentError => e
    puts e.message
  end
end