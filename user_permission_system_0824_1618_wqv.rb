# 代码生成时间: 2025-08-24 16:18:25
# user_permission_system.rb
# This Hanami application implements a user permission management system.

require 'hanami'
require 'hanami/model'
require 'hanami/model/sql'
require 'hanami/model/mapping'
require 'hanami/validations'
require 'bcrypt'

# Entity for User
class UserEntity < Hanami::Entity
  # Define attributes
  attributes :id, :email, :password_hash, :permissions

  # Validations
  validations do
    # Email must be present and unique
    required :email
    # Password must be present and have at least 8 characters
    required :password_hash, length: { minimum: 8 }
    # Permissions must be an array of strings
    required :permissions, array_of: String
  end
end

# Repository for User
class UserRepository < Hanami::Repository
  def initialize(user_entity: UserEntity)
    super(user_entity)
  end

  # Find a user by email
  def find_by_email(email)
    query(:users).where(email: email).one
  end

  # Save a new user
  def create_user(email:, password:, permissions:)
    user = UserEntity.new(email: email, password_hash: hash_password(password), permissions: permissions)
    super(user)
  end

  # Update user permissions
  def update_permissions(user_id, permissions)
    self[user_id].permissions = permissions
    save_changes(user_id)
  end

  private

  # Hash the password using BCrypt
  def hash_password(password)
    BCrypt::Password.create(password)
  end
end

# Service for user permissions management
class UserPermissionService
  # Initialize with user repository
  def initialize(user_repository: UserRepository.new)
    @user_repository = user_repository
  end

  # Create a new user with permissions
  def create_user(email:, password:, permissions:)
    @user_repository.create_user(email: email, password: password, permissions: permissions)
  rescue Hanami::Model::Validation::Error => e
    puts 'User creation failed due to validation errors: ' + e.record.errors.to_s
  end

  # Update user permissions
  def update_user_permissions(user_id, permissions)
    @user_repository.update_permissions(user_id, permissions)
  rescue Hanami::Model::Validation::Error => e
    puts 'Updating user permissions failed due to validation errors: ' + e.record.errors.to_s
  end
end

# CLI module for interacting with the user permission system
module UserPermissionCLI
  def self.start
    service = UserPermissionService.new
    puts 'User Permission Management System CLI'
    loop do
      puts 'Choose an action:'
      puts '1. Create a new user'
      puts '2. Update user permissions'
      puts '3. Exit'
      action = gets.chomp

      case action
      when '1'
        email = gets.chomp
        password = gets.chomp
        permissions = gets.chomp.split(',').map(&:strip)
        service.create_user(email: email, password: password, permissions: permissions)
      when '2'
        user_id = gets.chomp
        permissions = gets.chomp.split(',').map(&:strip)
        service.update_user_permissions(user_id, permissions)
      when '3'
        break
      else
        puts 'Invalid action. Please choose again.'
      end
    end
  end
end

# Run the CLI
UserPermissionCLI.start