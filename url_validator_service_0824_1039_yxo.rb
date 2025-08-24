# 代码生成时间: 2025-08-24 10:39:49
# url_validator_service.rb
# This service is responsible for validating URL links using Hanami framework.

require 'hanami'
require 'hanami/validation'
require 'uri'
require 'net/http'

# Service class for URL validation
class UrlValidatorService
  # Validate the given URL
  #
  # @param url [String] The URL to be validated
  # @return [Boolean] True if the URL is valid, false otherwise
  def validate(url)
    # Use URI to parse the URL and check its format
    begin
      uri = URI.parse(url)
      # Check if the URI is valid (has scheme and host)
      return false unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)

      # Use Net::HTTP to check if the URL is reachable
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https')

      # Check the response status code to determine if the URL is valid
      response = http.head('/')
      response.code.to_i == 200
    rescue URI::InvalidURIError, SocketError, OpenSSL::SSL::SSLError
      # If any exception is raised, the URL is considered invalid
      false
    end
  end
end

# Example usage:
# validator = UrlValidatorService.new
# puts validator.validate("https://www.example.com") # true or false