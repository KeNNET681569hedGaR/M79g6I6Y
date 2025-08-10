# 代码生成时间: 2025-08-11 00:27:42
# file_backup_sync.rb
# 这是一个使用RUBY和HANAMI框架的文件备份和同步工具

require 'hanami'
require 'fileutils'
require 'digest'
require 'logger'

# 定义一个类来处理文件备份与同步
class FileBackupSync
  # 构造器，初始化源目录和目标目录
  def initialize(source, destination)
    @source = source
    @destination = destination
    @logger = Logger.new(STDOUT)
  end

  # 同步文件的方法
  def sync_files
    backup_files
    copy_new_files
    remove_deleted_files
  end

  private

  # 备份源目录文件的方法
  def backup_files
    Dir.glob("#{@source}/**/*").each do |file|
      relative_path = file.sub(@source, '')
      destination_path = "#{@destination}#{relative_path}"
      FileUtils.mkdir_p(File.dirname(destination_path)) unless Dir.exist?(File.dirname(destination_path))
      file_checksum = Digest::SHA256.hexdigest(File.read(file))
      if File.exist?(destination_path)
        updated_checksum = Digest::SHA256.hexdigest(File.read(destination_path))
        if file_checksum != updated_checksum
          FileUtils.cp(file, destination_path)
          @logger.info("文件已更新: #{file}")
        end
      else
        FileUtils.cp(file, destination_path)
        @logger.info("文件已复制: #{file}")
      end
    end
  end

  # 复制新文件的方法
  def copy_new_files
    Dir.glob("#{@destination}/**/*").each do |file|
      relative_path = file.sub(@destination, '')
      source_path = "#{@source}#{relative_path}"
      unless File.exist?(source_path)
        FileUtils.rm(file)
        @logger.info("文件已删除: #{file}")
      end
    end
  end

  # 删除已删除文件的方法
  def remove_deleted_files
    Dir.glob("#{@source}/**/*").each do |file|
      relative_path = file.sub(@source, '')
      destination_path = "#{@destination}#{relative_path}"
      unless File.exist?(destination_path)
        FileUtils.rm(file)
        @logger.info("文件已删除: #{file}")
      end
    end
  end
end

# 使用示例
if __FILE__ == $0
  source_directory = "./source"
  destination_directory = "./destination"
  backup_sync = FileBackupSync.new(source_directory, destination_directory)
  backup_sync.sync_files
end