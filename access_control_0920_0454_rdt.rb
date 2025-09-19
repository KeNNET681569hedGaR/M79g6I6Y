# 代码生成时间: 2025-09-20 04:54:41
# 使用 Hanami 框架实现访问权限控制
#
# @author 你的名字
# @version 1.0

require 'hanami'
require 'hanami/model'

# 定义一个用户模型
class User
  include Hanami::Entity
  include Hanami::Model:: Associations::OneToOne
  include Hanami::Model::Associations::OneToMany
  include Hanami::Model:: Associations::ManyToMany
  include Hanami::Model:: Associations::ManyToNone

  # 定义用户属性
  attributes :id, :username, :password, :role, :created_at, :updated_at
end

# 定义角色模型
class Role
  include Hanami::Entity
  include Hanami::Model:: Associations::OneToOne
  include Hanami::Model::Associations::OneToMany
  include Hanami::Model:: Associations::ManyToMany
  include Hanami::Model:: Associations::ManyToNone

  # 定义角色属性
  attributes :id, :name, :permissions
end

# 定义访问权限控制类
class AccessControl
  # 检查用户是否有访问权限
  def self.check_access(user, action)
    # 获取用户角色
    user_role = user.role

    # 获取角色权限
    role_permissions = user_role.permissions

    # 检查权限是否存在
    if role_permissions.include?(action)
      # 权限存在，允许访问
      true
    else
      # 权限不存在，拒绝访问
      false
    end
  end
end

# 示例用法
user = User.new(username: 'John', password: '123456')
role = Role.new(name: 'admin', permissions: ['read', 'write', 'delete'])
user.role = role

# 检查用户是否有读取权限
has_read_access = AccessControl.check_access(user, 'read')
puts "User has read access: #{has_read_access}"

# 检查用户是否有写入权限
has_write_access = AccessControl.check_access(user, 'write')
puts "User has write access: #{has_write_access}"

# 检查用户是否有删除权限
has_delete_access = AccessControl.check_access(user, 'delete')
puts "User has delete access: #{has_delete_access}"
