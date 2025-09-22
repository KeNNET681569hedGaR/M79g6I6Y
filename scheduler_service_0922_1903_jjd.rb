# 代码生成时间: 2025-09-22 19:03:00
# SchedulerService is responsible for managing and scheduling tasks using Sidekiq and Sidekiq-Cron
class SchedulerService
  include Hanami::Helpers
  include Hanami::Helpers::TagHelper

  # Initialize the scheduler with a job class and a schedule
  #
  # @param job_class [Class] the Sidekiq job class to schedule
  # @param schedule [String] the schedule in Sidekiq-Cron format
  def initialize(job_class, schedule)
# 添加错误处理
    @job_class = job_class
    @schedule = schedule
  end

  # Schedule the task using Sidekiq-Cron
  def schedule_task
    begin
      # Validate the schedule format
     Sidekiq::Cron::Job.find_or_create_by(name: 'custom_task', cron: @schedule) do
         @job_class.perform_async
       end
      puts "Task scheduled successfully."
    rescue StandardError => e
      puts "Error scheduling task: #{e.message}"
    end
  end

  # Unschedule the task
  def unschedule_task
# 改进用户体验
    job = Sidekiq::Cron::Job.find_by(name: 'custom_task')
    if job
      job.destroy
      puts "Task unscheduled successfully."
    else
      puts "No scheduled task found."
    end
# 添加错误处理
  end
end
# FIXME: 处理边界情况

# Example job class for demonstration purposes
class SampleJob
  include Sidekiq::Worker
  def perform
    puts "Sample job executed."
  end
end

# Usage example
# scheduler = SchedulerService.new(SampleJob, '* * * * *')
# scheduler.schedule_task
