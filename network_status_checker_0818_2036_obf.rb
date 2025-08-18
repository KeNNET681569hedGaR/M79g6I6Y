# 代码生成时间: 2025-08-18 20:36:24
# NetworkStatusChecker class using Hanami framework
class NetworkStatusChecker
  # Initializes the checker with a hostname to test
  #
  # @param hostname [String] the hostname or IP address to check
  attr_reader :hostname

  def initialize(hostname)
    @hostname = hostname
  end

  # Checks if the network connection to the hostname is active
  #
  # @return [Boolean] whether the connection is active or not
  def active?
    begin
      Timeout.timeout(5) do
        TCPSocket.new(hostname, 80)
      end
      true
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Timeout::Error, SocketError => e
      handle_error(e)
      false
    end
  end

  private

  # Handles the errors occurred during the network check
  #
  # @param error [Exception] the error that occurred
  def handle_error(error)
    puts "Network check failed: #{error.message}"
  end
end

# Example usage
if __FILE__ == $0
  hostname = 'www.google.com'
  checker = NetworkStatusChecker.new(hostname)

  if checker.active?
    puts "The network connection to #{hostname} is active."
  else
    puts "The network connection to #{hostname} is not active."
  end
end