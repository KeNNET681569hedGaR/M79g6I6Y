# 代码生成时间: 2025-08-26 12:28:19
# user_authentication.rb
# This script handles user authentication using the Hanami framework.

require 'hanami'
require 'hanami/model'
require 'bcrypt'

module Authentication
  # User model that includes authentication functionality.
  class User
    include Hanami::Entity
    include Hanami::Model::Validations

    attributes :username, :password_digest, :salt

    # Validations for user inputs.
    validations do
      required(:username).filled
      required(:password).filled
      # Add more validations as needed.
    end

    # Encrypt the password before saving it to the database.
    def password=(new_password)
      self.salt = BCrypt::Engine.generate_salt
      self.password_digest = BCrypt::Engine.hash_secret(new_password, salt)
    end

    # Authenticate a user by comparing the provided password with the stored hash.
    def self.authenticate(username, password)
      user = UserRepository.new.find_by_username(username)
      if user && user.encrypted_password == BCrypt::Engine.hash_secret(password, user.salt)
        user
      else
        nil
      end
    end
  end

  # UserRepository represents the repository pattern for interacting with the User model.
  class UserRepository
    include Hanami::Repository

    # Find a user by username.
    def find_by_username(username)
      User.find_by(username: username)
    end

    # Add more methods for interacting with the User model as needed.
  end

  # AuthenticationService handles the authentication logic.
  class AuthenticationService
    # Attempt to authenticate a user and return the user object if successful.
    def authenticate(username, password)
      user = User.authenticate(username, password)
      if user
        user
      else
        raise Hanami::Validations::ValidationError.new('Invalid credentials')
      end
    end
  end
end
