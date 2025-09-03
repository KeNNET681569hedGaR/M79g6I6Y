# 代码生成时间: 2025-09-04 00:17:53
# user_permission_system.rb
#
# 用户权限管理系统
#
# 这是一个基于 Ruby 和 Hanami 框架的用户权限管理系统的例子。

require 'hanami'

# 定义 User 模型
class User
  include Hanami::Entity

  # 用户属性
  attributes :id, :name, :email, :role
end

# 定义 Permission 模型
class Permission
  include Hanami::Entity

  # 权限属性
  attributes :id, :action, :resource
end

# 用户权限管理服务
class UserPermissionService
  # 添加用户权限
  def self.add_permission(user_id, action, resource)
    user = User.find(user_id)
    if user
      permission = Permission.new(action: action, resource: resource)
      user.permissions << permission
      user.save
      true
    else
      false
    end
  end

  # 检查用户是否有权限
  def self.has_permission?(user_id, action, resource)
    user = User.find(user_id)
    if user && user.permissions.any?{ |permission| permission.action == action && permission.resource == resource }
      true
    else
      false
    end
  end
end

# 启动 Hanami 应用程序
Hanami.app
