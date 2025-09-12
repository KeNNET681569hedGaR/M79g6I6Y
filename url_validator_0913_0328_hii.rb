# 代码生成时间: 2025-09-13 03:28:21
# url_validator.rb
# This program validates the validity of a URL using the Hanami framework.

require 'hanami'
require 'hanami/controller'
require 'addressable/uri'
require 'uri'

class UrlValidator < Hanami::Controller
  # Validates the URL and returns a success message if the URL is valid
  # @param request [Hanami::Action::Request] the request object
  # @return [Hanami::Action::Response] a response object with the validation result
  action :validate do
    # Extract URL from request parameters
    url_to_validate = params['url']

    # Check if the URL is present in the request
    unless url_to_validate
      return json_response({ error: 'Missing URL parameter' }, 400)
    end

    # Validate the URL using Addressable::URI
    begin
      uri = Addressable::URI.parse(url_to_validate)
      unless uri.scheme && uri.host
        return json_response({ error: 'Invalid URL' }, 400)
      end
    rescue Addressable::URI::InvalidURIError
      return json_response({ error: 'Invalid URL' }, 400)
    end

    # Return a success response if the URL is valid
    json_response({ message: 'URL is valid' }, 200)
  end

  private
  # Helper method to generate a JSON response
  # @param data [Hash] data to be included in the response
  # @param status [Integer] HTTP status code for the response
  # @return [Hanami::Action::Response] a response object with JSON data
  def json_response(data, status)
    self.class.new.call(self.class.new.call(self.class.request), self.class.new.call(self.class.response)) do
      response.status = status
      response.body   = data.to_json
    end
  end
end