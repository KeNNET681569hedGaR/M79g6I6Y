# 代码生成时间: 2025-09-21 21:36:09
# 用户权限管理系统
# UserPermissionsSystem.rb

require 'hanami'
require 'hanami/model'
require 'hanami/model/mapping'
require 'hanami/model/adapters'
require 'hanami/model/adapters/sql'

# 定义用户模型
class User
  include Hanami::Entity
  # 用户表字段
  attributes :id, :username, :email, :role
end

# 定义角色模型
class Role
  include Hanami::Entity
  attributes :id, :name
end

# 定义用户权限模型
class UserPermission
  include Hanami::Entity
  attributes :user_id, :role_id
end

# 定义用户权限管理服务
class UserPermissionsService
  # 添加用户权限
  def add_user_permission(user_id, role_id)
    transaction do
      user_permission = UserPermission.new(user_id: user_id, role_id: role_id)
      user_permission.save or raise 'Failed to add user permission'
    end
  end

  # 删除用户权限
  def remove_user_permission(user_permission_id)
    transaction do
      user_permission = UserPermission.find(user_permission_id)
      user_permission.destroy if user_permission
    end
  rescue Hanami::Model::RecordNotFound
    raise 'User permission not found'
  end

  # 获取用户权限
  def get_user_permissions(user_id)
    transaction do
      UserPermission.where(user_id: user_id).to_a.map do |permission|
        { user_id: permission.user_id, role_id: permission.role_id }
      end
    end
  end
end

# 数据库配置
Hanami::Model.configure do
  adapter :sql, 'postgres://user_permissions_system'
end

# 初始化数据库映射
Hanami::Model.mapping do
  collection :users do
    entity User
    attribute :id, Integer
    attribute :username, String
    attribute :email, String
    attribute :role, String
  end

  collection :roles do
    entity Role
    attribute :id, Integer
    attribute :name, String
  end

  collection :user_permissions do
    entity UserPermission
    attribute :user_id, Integer
    attribute :role_id, Integer
  end
end

# 初始化数据库连接
Hanami::Model.load_configuration
Hanami::Model.connect

# 示例用法
service = UserPermissionsService.new
begin
  service.add_user_permission(1, 1)
  puts 'User permission added successfully'
rescue => e
  puts 'Error: ' + e.message
end

begin
  permissions = service.get_user_permissions(1)
  puts 'User permissions: ' + permissions.inspect
rescue => e
  puts 'Error: ' + e.message
end

begin
  service.remove_user_permission(1)
  puts 'User permission removed successfully'
rescue => e
  puts 'Error: ' + e.message
end
