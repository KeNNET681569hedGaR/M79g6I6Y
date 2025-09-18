# 代码生成时间: 2025-09-18 13:34:32
# config_manager.rb
require 'hanami'

# ConfigManager负责处理配置文件的管理
class ConfigManager
  # 定义配置文件的路径
  CONFIG_PATH = 'config/settings.yml'

  # 初始化配置管理器
  # @param config_path [String] 配置文件的路径
  def initialize(config_path = CONFIG_PATH)
    @config_path = config_path
    load_config
  end

  # 加载配置文件
  # @return [Hash] 配置文件内容
  def load_config
    # 检查配置文件是否存在
    raise "Configuration file not found at #{@config_path}" unless File.exist?(@config_path)

    # 加载YAML配置文件
    @config = YAML.load_file(@config_path)
  rescue StandardError => e
    raise "Failed to load configuration: #{e.message}"
  end

  # 获取配置项的值
  # @param key [String] 配置项的键
  # @return [String] 配置项的值
  def get(key)
    raise "Key not found in configuration: #{key}" unless @config.key?(key)
    @config[key.to_sym]
  end

  # 设置配置项的值
  # @param key [String] 配置项的键
  # @param value [String] 配置项的值
  def set(key, value)
    @config[key.to_sym] = value
    save_config
  end

  # 保存配置文件
  def save_config
    File.open(@config_path, 'w') do |file|
      file.write(@config.to_yaml)
    end
  rescue StandardError => e
    raise "Failed to save configuration: #{e.message}"
  end
end
