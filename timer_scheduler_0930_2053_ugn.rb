# 代码生成时间: 2025-09-30 20:53:01
# timer_scheduler.rb
#
# A simple scheduled task scheduler using Ruby and Hanami framework.
#
# @author Your Name
# @created_at 2023-04-01

require 'hanami'
require 'concurrent'
require 'logger'

# Define a TimerScheduler class to encapsulate scheduling logic
class TimerScheduler
  # Initialize the scheduler with a Hanami app and a logger
  def initialize(app, logger: Logger.new(STDOUT))
    @app = app
    @logger = logger
    @scheduler = Concurrent::TimerSet.new
  end

  # Schedule a task to run at a specified interval
  def schedule(interval, name:, &block)
    @logger.info("Scheduling task: #{name}, interval: #{interval} seconds")
    @scheduler[