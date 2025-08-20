# 代码生成时间: 2025-08-21 04:54:25
# FolderOrganizer is a Hanami service that organizes a directory structure
class FolderOrganizer
  # Initialize with the target directory path
  # @param directory_path [String] The path to the directory to be organized
  def initialize(directory_path)
    @directory_path = directory_path
  end

  # Organize the directory structure
  # This method will sort files into folders based on their extension
  # @return [Array<String>] An array of messages indicating the actions performed
  def organize
    return [] unless File.exist?(@directory_path)
    return [] unless File.directory?(@directory_path)

    messages = []
    extensions = {}
    Dir.glob(File.join(@directory_path, '**', '*')).each do |file_path|
      next if File.directory?(file_path)

      extension = File.extname(file_path)[1..-1].downcase # Get the file extension
      extension = 'others' if extension.empty? # Default to 'others' if no extension

      # Create a folder for the extension if it doesn't exist
      unless extensions.key?(extension)
        folder_path = File.join(@directory_path, extension)
        FileUtils.mkdir_p(folder_path)
        messages << "Created folder: #{folder_path}"
        extensions[extension] = folder_path
      end

      # Move file to the appropriate folder
      dest_path = File.join(extensions[extension], File.basename(file_path))
      FileUtils.mv(file_path, dest_path, force: true)
      messages << "Moved file: #{file_path} to #{dest_path}"
    end

    messages
  end
end

# Usage example
if __FILE__ == $0
  target_directory = ARGV[0] || './'
  organizer = FolderOrganizer.new(target_directory)
  messages = organizer.organize
  puts 'Organization complete with the following actions:'
  puts messages.join("
")
rescue StandardError => e
  puts "An error occurred: #{e.message}"
end
