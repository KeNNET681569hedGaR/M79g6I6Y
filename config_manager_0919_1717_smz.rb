# 代码生成时间: 2025-09-19 17:17:15
# 配置文件管理器
# 用于加载、解析和配置Hanami框架的配置文件

require 'hanami'
require 'yaml'

module ConfigManager
  # 配置文件路径
  CONFIG_PATH = 'config/'

  # 加载配置文件
  # @param file_name [String] 配置文件名称（不包含路径和后缀）
  # @return [Hash] 配置文件内容
  def self.load_config(file_name)
    file_path = File.join(CONFIG_PATH, file_name)
    raise "Configuration file not found: #{file_path}" unless File.exist?(file_path)

    config_content = File.read(file_path)
    YAML.safe_load(config_content)
  end

  # 保存配置文件
  # @param file_name [String] 配置文件名称（不包含路径和后缀）
  # @param config_data [Hash] 要写入的配置数据
  def self.save_config(file_name, config_data)
    file_path = File.join(CONFIG_PATH, file_name)
    File.write(file_path, config_data.to_yaml)
  end

  # 更新配置文件
  # @param file_name [String] 配置文件名称（不包含路径和后缀）
  # @param update_data [Hash] 要更新的配置数据
  def self.update_config(file_name, update_data)
    config = load_config(file_name)
    config.merge!(update_data)
    save_config(file_name, config)
  end

  # 删除配置文件
  # @param file_name [String] 配置文件名称（不包含路径和后缀）
  def self.delete_config(file_name)
    file_path = File.join(CONFIG_PATH, file_name)
    raise "Configuration file not found: #{file_path}" unless File.exist?(file_path)

    File.delete(file_path)
  end
end

# 示例用法：
# config = ConfigManager.load_config('database')
# config = ConfigManager.update_config('database', {'adapter' => 'postgresql'})
# ConfigManager.save_config('database', config)
