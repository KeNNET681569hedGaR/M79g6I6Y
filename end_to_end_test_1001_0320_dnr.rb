# 代码生成时间: 2025-10-01 03:20:21
# end_to_end_test.rb
#
# This script demonstrates how to implement an end-to-end testing framework
# using Ruby and the Hanami framework.

# Import necessary Hanami components
require 'hanami'
require 'hanami/view'
require 'hanami/test'
require_relative 'application'

# Set up the test environment
Hanami.boot

# Define an end-to-end test class
class EndToEndTest < Hanami::Test::Container
  # Include the necessary modules for testing
  include Hanami::Test::Helpers::HTTP
  include Hanami::Test::Helpers::Form
  include Hanami::Test::Helpers::Flash
  include Hanami::Test::Helpers::Session
  include Hanami::Test::Helpers::Cookies

  # Define the test for the application
  def test_application_flow
    # Start with the home page
    get '/'
    follow_redirect!
    assert_status(200)
    assert_body(/"Welcome to Hanami"/)

    # Navigate to the signup page
    click_on 'Sign up'
    assert_status(200)
    assert_body(/signup form/)

    # Submit the signup form with valid credentials
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password'
    submit_form
    assert_status(302)  # Expect a redirect after successful signup
    follow_redirect!
    assert_body(/Welcome, user@example.com!/)

    # Log out and end the test
    click_on 'Log out'
    assert_status(200)
    assert_body(/Logged out successfully/)
  end

  # Add more tests as needed, following the same pattern
end

# Run the test
test = EndToEndTest.new
test.test_application_flow
puts 'End-to-end test completed successfully!'
