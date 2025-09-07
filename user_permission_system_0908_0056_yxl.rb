# 代码生成时间: 2025-09-08 00:56:10
# user_permission_system.rb
#
# User Permission Management System using Hanami Framework

require 'hanami'
require 'hanami/model'
require 'hanami/model/adapters/sqlite'
require 'bcrypt'

# Define the User entity
class User < Hanami::Entity
  include Hanami::Model::Timestamps
  include Hanami::Model::Validations

  attributes :id, :username, :password_digest, :admin, :permissions

  validations do
    required :username, :password_digest
  end
end

# Define the User Repository
class UserRepository < Hanami::Repository
  def create_user_with_password(username, password, admin = false, permissions = [])
    BCrypt::Password.create(password).tap do |password_digest|
      create(username: username, password_digest: password_digest, admin: admin, permissions: permissions)
    end
  end

  def find_user_by_username(username)
    find_by(username: username)
  end
end

# Define the User Service
class UserService
  include Hanami::Service
  include Hanami::Service::Callbacks

  before :validate_user

  def call(username, password)
    user = UserRepository.new.find_user_by_username(username)
    if user && user.authenticate(password)
      user
    else
      raise Hanami::Service::Error, 'Invalid username or password'
    end
  end

  private

  def validate_user
    unless UserRepository.new.find_user_by_username(params[:username])
      raise Hanami::Service::Error, 'User does not exist'
    end
  end
end

# Define the User Controller
class UserController < Hanami::Controller
  include Hanami::Action::Entity
  include Hanami::Action::Cookies
  include Hanami::Action::Flash

  def create
    service = UserService.new.call(params[:username], params[:password])
    if service.success?
      flash[:success] = 'User created successfully'
      redirect to: '/users/list'
    else
      flash[:error] = service.error.message
      redirect to: '/users/new'
    end
  end
end

# Define the User Migration
Hanami::Model.migration do
  change do
    create_table :users do
      primary_key :id
      column :username, String, null: false
      column :password_digest, String, null: false
      column :admin, TrueClass, null: false, default: false
      column :permissions, Array, null: false, default: []
    end
  end
end

# Define the User Route
Hanami::Router.new do
  get '/users', to: 'users#index'
  post '/users', to: 'users#create'
end

# Usage
# 1. Run the migration to create the users table
#   `hanami db migrate`

# 2. Start the Hanami application
#   `hanami start`

# 3. Access the user creation form at `/users/new`
# 4. Submit the form to `/users` to create a new user
