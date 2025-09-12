# 代码生成时间: 2025-09-12 14:55:56
# frozen_string_literal: true

# FormValidator
# A Hanami form validator class that ensures submitted data meets specified criteria.

class FormValidator < Hanami::Entity::Validator
  # Define the validation rules for the form
  # Each rule must be registered in the corresponding form entity
  validations do
    # Example validation: Ensure 'username' is present and not empty
    required(:username).filled
    # Example validation: Ensure 'email' is present, not empty, and is a valid email format
    required(:email).filled & email
    # Example validation: Ensure 'password' is at least 8 characters long
    required(:password).filled & length{ minimum: 8 }
  end

  # Method to validate the form data
  # @param data [Hash] The form data to be validated
  # @return [Array<String>] An array of error messages if the data is invalid, otherwise an empty array
  def validate(data)
    super(data) # Validate using Hanami's built-in validation system
    messages = super
    messages.empty? ? [] : messages.map(&:to_s)
  end

  # Handle any errors that occur during validation
  def handle_errors(messages)
    unless messages.empty?
      raise Hanami::Entity::Validation::Errors.new(messages)
    end
  end
end
