# 代码生成时间: 2025-10-03 19:54:54
# version_control_system.rb
#
# Simple version control system using Ruby and Hanami framework
#
# @author Your Name
# @date 2023-04-01

require 'hanami'

module VersionControl
  class System
    # Initialize system with a repository path
    def initialize(path)
      @path = path
    end

    # Add file to the repository
    def add(file)
      unless File.exist?(file)
        raise "File does not exist: #{file}"
      end

      repository_path = File.join(@path, 'repo', File.basename(file))
      FileUtils.mkdir_p(File.dirname(repository_path))
      File.open(repository_path, 'wb') do |f|
        f.write File.read(file)
      end
    end

    # Commit changes with a message
    def commit(message)
      raise "No files staged for commit" if Dir.glob(File.join(@path, 'repo', '*')).empty?

      Dir.glob(File.join(@path, 'repo', '*')).each do |file|
        original_path = File.join(@path, File.basename(file))
        File.open(original_path, 'wb') do |f|
          f.write File.read(file)
        end
      end

      File.open(File.join(@path, 'commit_message.txt'), 'w') do |f|
        f.write message
      end
    end

    # Revert changes by removing all changes in the 'repo' directory
    def revert
      FileUtils.rm_rf(File.join(@path, 'repo'))
    end

    # Display current files in the repository
    def status
      files = Dir.glob(File.join(@path, 'repo', '*')).map { |f| File.basename(f) }
      files.empty? ? "No files staged for commit" : files.join(', ')
    end
  end
end

# Usage example
if __FILE__ == $0
  repo_path = './my_repo'
  vcsystem = VersionControl::System.new(repo_path)

  begin
    vcsystem.add('./example.txt')
    vcsystem.commit('Initial commit')
    puts vcsystem.status
    vcsystem.revert
    puts vcsystem.status
  rescue => e
    puts "Error: #{e.message}"
  end
end