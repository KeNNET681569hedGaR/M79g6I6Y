# 代码生成时间: 2025-08-22 15:10:18
# encoding: utf-8
require 'hanami'
require 'hanami/helpers'
require 'hanami/helpers/html_escape'

# XSS Protection Module
module XssProtection
  include Hanami::Helpers::HtmlEscape
  
  # Sanitize input to prevent XSS attacks
  #
  # @param [String] input The input string to sanitize
  # @return [String] The sanitized input string
  #
  def sanitize_input(input)
    unless input.is_a?(String)
      raise ArgumentError, 'Input must be a string'
    end
    "#{html_escape(input)}"
  end
end

# Controller that uses XSS protection
class MainController < Hanami::Controller
  include XssProtection
  
  # GET /
  #
  # @return [void]
  #
  def index
    @user_input = params[:user_input]
    @sanitized_input = sanitize_input(@user_input)
    render 'index'
  end
end

# View template for the index action
# This template escapes output to prevent XSS attacks
#
# @param [String] sanitized_input The sanitized input string
#
# @return [void]
#
template :index, '<html>
<head>
  <title>XSS Protection</title>
</head>
<body>
  <h1>XSS Protection</h1>
  <p>User Input:</p>
  <p><%= sanitized_input %></p>
</body>
</html>'