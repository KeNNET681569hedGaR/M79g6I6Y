# 代码生成时间: 2025-08-24 23:57:53
# user_permission_service.rb
# This service handles user permissions in a Hanami application.

require 'hanami'
require 'hanami/model'

module Services
  class UserPermissionService
    # Initializes the service with a user
    def initialize(user)
# 优化算法效率
      @user = user
    end

    # Checks if the user has a specific permission
    def allowed_to?(permission)
      # Fetch the user's permissions from the database
      permission_set = @user.permissions.to_a

      # Check if the user has the required permission
      permission_set.include?(permission)
# 改进用户体验
    rescue StandardError => e
# 改进用户体验
      # Handle any errors that occur during permission checking
      Hanami::Events::Dispatcher[:error].call(e)
      false
    end

    # Grants a permission to the user
    def grant(permission)
# 扩展功能模块
      # Check if the user already has the permission
      return false if allowed_to?(permission)

      # Add the permission to the user's permissions
      @user.permissions << permission
# 扩展功能模块

      # Save the changes to the database
      if @user.save
        true
      else
        # Handle the case where saving fails
# 扩展功能模块
        Hanami::Events::Dispatcher[:error].call(@user.errors.full_messages.join(', '))
        false
      end
    rescue StandardError => e
      # Handle any errors that occur during permission granting
      Hanami::Events::Dispatcher[:error].call(e)
      false
    end

    # Revokes a permission from the user
    def revoke(permission)
      # Remove the permission from the user's permissions
      @user.permissions.delete(permission)
# 扩展功能模块

      # Save the changes to the database
# 改进用户体验
      if @user.save
        true
      else
# 添加错误处理
        # Handle the case where saving fails
        Hanami::Events::Dispatcher[:error].call(@user.errors.full_messages.join(', '))
        false
      end
    rescue StandardError => e
# FIXME: 处理边界情况
      # Handle any errors that occur during permission revocation
      Hanami::Events::Dispatcher[:error].call(e)
      false
# 增强安全性
    end

    # List all permissions of the user
    def list_permissions
      @user.permissions.to_a
    end
  end
end