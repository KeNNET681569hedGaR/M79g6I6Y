# 代码生成时间: 2025-09-15 22:31:04
# ErrorLoggerService.rb
# This service is responsible for collecting error logs in a Hanami application.
# TODO: 优化性能

require 'hanami'
require 'logger'

# Service for error logging
# FIXME: 处理边界情况
class ErrorLoggerService
  # Initialize the logger with the path to the log file
  def initialize(log_file_path = 'error_log.log')
    @logger = Logger.new(log_file_path)
  end

  # Log an error with a message and an error level
  def log_error(message, level = 'error')
    # Check if the level is valid
    raise ArgumentError, 'Invalid log level' unless %w[debug info warn error fatal].include?(level.to_s)

    # Log the error message with the provided level
    @logger.send(level, message)
  end

  # Close the logger
  def close
    @logger.close
  end
end
