# 代码生成时间: 2025-08-19 13:07:28
# url_validator.rb
# This script validates the validity of a URL using Ruby and Hanami framework.

require 'hanami/controller'
require 'uri'

# A Hanami controller for validating URLs
class UrlValidatorController < Hanami::Controller
  # GET /validate
  def call
    # Retrieve the URL from the query parameters
    url = params.fetch(:url)
    
    # Validate the URL and respond with the result
    if valid_url?(url)
      response.write("URL is valid")
    else
      response.write("URL is invalid")
    end
  end

  private
  
  # Helper method to check if the URL is valid
  def valid_url?(url)
    # Use URI to validate the URL
    begin
      uri = URI.parse(url)
      %w( http https ).include?(uri.scheme)
    rescue URI::InvalidURIError
      false
    end
  end
end