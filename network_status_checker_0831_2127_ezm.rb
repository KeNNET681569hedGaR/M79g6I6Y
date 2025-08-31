# 代码生成时间: 2025-08-31 21:27:40
# NetworkStatusChecker is a Hanami service that checks the network connection status.
class NetworkStatusChecker < Hanami::Service
  # Check if the network connection is available.
  #
  # @param [String] hostname The hostname or IP address to check.
  # @return [Boolean] True if the network connection is available, otherwise false.
  #
  # @raise [StandardError] If there is an error during the network check.
  def call(hostname:)
    # Check if the hostname is provided and is not empty.
    unless hostname.present?
      raise ArgumentError, 'Hostname must be provided'
    end

    # Try to establish a connection to the provided hostname.
    begin
      Timeout.timeout(5) do
        TCPSocket.new(hostname, 80).close
        # If the connection was successful, return true.
        true
      end
    rescue Timeout::Error, SocketError => e
      # If a timeout or socket error occurs, return false.
      false
    rescue StandardError => e
      # If any other error occurs, raise a StandardError.
      raise StandardError, 'An error occurred while checking the network status'
    end
  end
end

# Example usage:
# checker = NetworkStatusChecker.new
# is_connected = checker.call(hostname: 'www.google.com')
# puts 'Network connection is available' if is_connected
