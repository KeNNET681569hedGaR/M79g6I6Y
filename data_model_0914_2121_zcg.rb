# 代码生成时间: 2025-09-14 21:21:44
# data_model.rb
require 'hanami/model'
require 'data_model/entities/user'

# Define the application's schema
module DataModel
  extend Hanami::Model::DSL

  # Add your migrations here
  # migration :create_users do
  #   change do
  #     create_table :users do
  #       primary_key :id
  #       column :name, String, null: false
  #       column :email, String, null: false, unique: true
  #     end
  #   end
  # end
end

# Define the application's entities
module Entities
  # User entity
  class User
    include Hanami::Entity
  end
end

# Usage example:
# user = Entities::User.new(id: 1, name: 'John Doe', email: 'john@example.com')
# user = DataModel.repository(:users).insert(user)
# user = DataModel.repository(:users).find(1)
# puts user.name # => John Doe
