# 代码生成时间: 2025-08-13 16:53:56
# frozen_string_literal: true

# SchedulerService is a Hanami service that manages scheduling tasks.
# It includes error handling, documentation, and follows Ruby best practices.
class SchedulerService < Hanami::Service::Base
  # Call the service to schedule a task
  #
  # @param [String] task_name the name of the task to be scheduled
  # @param [Integer] interval the interval in seconds between task executions
  # @param [Proc] task the task to be executed
  #
  # @return [Boolean] true if the task was successfully scheduled, false otherwise
  def call(task_name:, interval:, task:)
    super do
      # Check if the task_name is valid and interval is a positive number
      unless task_name.is_a?(String) && interval.is_a?(Integer) && interval.positive?
        raise ArgumentError, 'Invalid task_name or interval'
      end

      # Check if the task is a callable object
      unless task.respond_to?(:call)
        raise ArgumentError, 'Task must be callable'
      end

      # Schedule the task using a thread to run in the background
      Thread.new do
        loop do
          sleep(interval)
          begin
            task.call
          rescue => e
            # Log the error and continue with the next iteration
            puts "Error executing task #{task_name}: #{e.message}"
          end
        end
      end
    end
  end
end

# Example usage of SchedulerService
if __FILE__ == $0
  require 'hanami'
  Hanami.boot

  # Define a simple task that prints the current time every 5 seconds
  task = Proc.new do
    puts "Task executed at #{Time.now}"
  end

  # Create an instance of SchedulerService and schedule the task
  scheduler_service = SchedulerService.new
  result = scheduler_service.call(task_name: 'print_time', interval: 5, task: task)
  puts "Task scheduled: #{result}"
end