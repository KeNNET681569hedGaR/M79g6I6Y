# 代码生成时间: 2025-08-20 16:18:57
# process_manager.rb

# 进程管理器类
class ProcessManager
  # 初始化进程管理器
  def initialize
    @processes = {}
  end

  # 添加进程
  # @param name [String] 进程名称
  # @param pid [Integer] 进程ID
  def add_process(name, pid)
    if @processes.has_key?(name)
      raise 'Process already exists'
    else
      @processes[name] = pid
    end
  end

  # 移除进程
  # @param name [String] 进程名称
  def remove_process(name)
    if @processes.has_key?(name)
      @processes.delete(name)
    else
      raise 'Process not found'
    end
  end

  # 终止进程
  # @param name [String] 进程名称
  def terminate_process(name)
    if @processes.has_key?(name)
      Process.kill('TERM', @processes[name])
      remove_process(name)
    else
      raise 'Process not found'
    end
  end

  # 获取所有进程
  # @return [Hash] 所有进程及其ID
  def get_processes
    @processes
  end
end

# 示例用法
if __FILE__ == $PROGRAM_NAME
  # 创建进程管理器实例
  manager = ProcessManager.new

  # 添加一些进程
  manager.add_process('process1', 1234)
  manager.add_process('process2', 5678)

  # 获取所有进程
  puts 'Current processes:'
  puts manager.get_processes

  # 终止一个进程
  manager.terminate_process('process1')

  # 再次获取所有进程
  puts 'Processes after termination:'
  puts manager.get_processes
end