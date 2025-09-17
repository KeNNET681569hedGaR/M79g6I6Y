# 代码生成时间: 2025-09-18 01:30:03
# Hanami Application
class UrlValidator < Hanami::Controller

  # Validates a URL
  #
  # @param request [Hanami::Action::Params] the HTTP request parameters
  #
  # @return [Hanami::Action::Response] the HTTP response
  #
  def call(request)
    # Parse the URL from the request
    url = request.params.fetch(:url)

    # Validate the URL
    begin
      uri = URI.parse(url)

      # Check if the URL is valid
      if uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
        response = { status: :ok, body: "The URL is valid" }
      else
        response = { status: :bad_request, body: "Invalid URL scheme. Only HTTP and HTTPS are allowed." }
      end
    rescue URI::InvalidURIError
      # Handle invalid URLs
      response = { status: :bad_request, body: "Invalid URL format." }
    end

    # Return the response
    response(status: response[:status], body: response[:body])
  end

end