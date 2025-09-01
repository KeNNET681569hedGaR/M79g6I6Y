# 代码生成时间: 2025-09-02 00:14:22
# BatchRenameTool is responsible for renaming files in a directory.
class BatchRenameTool
  # Initialize the tool with the directory path and rename pattern.
  #
  # @param directory [String] the path to the directory containing files to rename.
  # @param pattern [String] the pattern to rename files with, e.g., 'new_prefix_{{index}}.ext'
  def initialize(directory, pattern = nil)
    @directory = directory
    @pattern = pattern
  end

  # Rename all files in the specified directory according to the pattern.
  # Each file will be renamed with a unique index appended to the pattern.
  #
  # @return [Array<String>] an array of renamed file paths.
  def rename_files
    files = Dir.glob(File.join(@directory, '*'))
    renamed_files = []
    files.each_with_index do |file, index|
      begin
        new_filename = generate_new_filename(file, index)
        FileUtils.mv(file, new_filename)
        renamed_files << new_filename
      rescue StandardError => e
        puts "Error renaming file #{file}: #{e.message}"
      end
    end
    renamed_files
  end

  private

  # Generate the new filename based on the given file and index.
  #
  # @param file [String] the path to the file to rename.
  # @param index [Integer] the index to append to the file name.
  # @return [String] the new filename.
  def generate_new_filename(file, index)
    filename = File.basename(file)
    new_name = @pattern.gsub('{{index}}', index.to_s)
    File.join(@directory, new_name)
  end
end

# Usage example:
#
# tool = BatchRenameTool.new('/path/to/directory', 'new_file_{{index}}.txt')
# renamed_files = tool.rename_files
# puts 'Renamed files:'
# renamed_files.each { |file| puts file }