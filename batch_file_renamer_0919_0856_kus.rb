# 代码生成时间: 2025-09-19 08:56:18
#!/usr/bin/env ruby

# batch_file_renamer.rb
# This script is a batch file renamer tool using Ruby and Hanami framework.

require 'hanami'
require 'hanami/helpers'
require 'fileutils'
require 'pathname'

# BatchFileRenamer class responsible for renaming files in a directory
class BatchFileRenamer
  include Hanami::Helpers
  
  # Initialize with directory path and rename pattern
  def initialize(directory, pattern)
    @directory = Pathname.new(directory)
    @pattern   = pattern
  end

  # Rename files in the directory based on the pattern
  def rename_files
    raise 'Directory does not exist' unless @directory.exist?
    
    @directory.each_child do |file|
      next unless file.file?
      
      new_name = file.basename.basename("#{file.extname}").to_s + @pattern + file.extname
      new_path = @directory.join(new_name)
      
      begin
        FileUtils.mv(file, new_path)
        puts "Renamed #{file} to #{new_path}"
      rescue StandardError => e
        puts "Error renaming #{file}: #{e.message}"
      end
    end
  end
end

# Example usage
if __FILE__ == $0
  directory = ARGV[0] || './'
  pattern   = ARGV[1] || "-Renamed"
  
  renamer = BatchFileRenamer.new(directory, pattern)
  renamer.rename_files
end