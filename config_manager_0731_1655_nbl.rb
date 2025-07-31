# 代码生成时间: 2025-07-31 16:55:35
# config_manager.rb
# This file is a configuration manager for Hanami framework applications.
# It provides a simple way to manage configuration files.

require 'hanami'
require 'hanami/utils/kernel'
require 'pathname'
require 'yaml'

# ConfigurationManager is a class responsible for managing configuration files.
class ConfigurationManager
  # Path to the configuration directory
  attr_reader :config_path

  # Initialize the Configuration Manager with a specific config path
  def initialize(config_path = './config')
    @config_path = Pathname.new(config_path)
    ensure_config_directory_exists!
  end

  # Load configuration from a file
  def load(file_name)
    return {} unless config_file_exists?(file_name)
    YAML.load_file(config_file_path(file_name))
  rescue StandardError => e
    handle_load_error(e, file_name)
  end

  # Save configuration to a file
  def save(file_name, config)
    config_file_path(file_name).open('w') do |file|
      file.write(config.to_yaml)
    end
  rescue StandardError => e
    handle_save_error(e, file_name)
  end

  private

  # Ensure the configuration directory exists
  def ensure_config_directory_exists!
    @config_path.mkpath unless @config_path.exist?
  end

  # Check if a configuration file exists
  def config_file_exists?(file_name)
    @config_path.join(file_name).exist?
  end

  # Get the full path to a configuration file
  def config_file_path(file_name)
    @config_path.join(file_name)
  end

  # Handle error when loading a configuration file
  def handle_load_error(error, file_name)
    puts "Error loading configuration file '#{file_name}': #{error.message}"
    {}
  end

  # Handle error when saving a configuration file
  def handle_save_error(error, file_name)
    puts "Error saving configuration file '#{file_name}': #{error.message}"
  end
end

# Example usage
# config_manager = ConfigurationManager.new
# environment_config = config_manager.load('environment.yml')
# puts environment_config
# config_manager.save('new_config.yml', { 'key' => 'value' })
