# 代码生成时间: 2025-09-14 12:07:21
# Hanami controller to validate URL links
class UrlValidator < Hanami::Controller
  # Validates the URL link and returns the result
  #
  # @param request [Hanami::Action::Request] The request object
  # @return [Hanami::Action::Response] The response object
  # @raise [StandardError] If the URL is invalid
  #
  # @example
  #   # Expected usage within a route
  #   post '/validate_url', to: UrlValidator, action: :validate
  action :validate do
    # Extract the URL from the request parameters
    url = params[:url]

    # Check if the URL is present and not empty
    unless url.present?
      body('URL is missing or empty')
      status(:bad_request)
      return
    end

    # Validate the URL format
    begin
      uri = URI.parse(url)
    rescue URI::InvalidURIError
      body('Invalid URL format')
      status(:bad_request)
      return
    end

    # Check if the scheme is supported (http or https)
    unless %w(http https).include?(uri.scheme)
      body('Unsupported URL scheme. Only http and https are allowed')
      status(:bad_request)
      return
    end

    # Attempt to connect to the URL to check its validity
    begin
      response = Net::HTTP.start(uri.host, uri.port) do |http|
        http.head(uri.path)
      end
    rescue SocketError, Net::HTTPServerException, Timeout::Error
      body('Failed to connect to the URL')
      status(:bad_request)
      return
    end

    # If the response code is 200, the URL is valid
    if response.code == '200'
      body('URL is valid')
      status(:ok)
    else
      body(