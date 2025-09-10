# 代码生成时间: 2025-09-10 19:23:06
# 使用 Hanami 框架的用户权限管理系统

# User 模型
class User
  include Hanami::Entity

  # 属性
  attributes :id, :name, :role_ids
end

# Role 模型
class Role
  include Hanami::Entity

  # 属性
  attributes :id, :name
end

# UserRepository 负责用户数据操作
class UserRepository
  def initialize(storage)
    @storage = storage
  end

  def create_user(name, role_ids)
    user = User.new(id: SecureRandom.uuid, name: name, role_ids: role_ids)
    @storage << user
    user
  rescue => e
    handle_error(e)
  end

  private
  def handle_error(e)
    # 错误处理逻辑
    puts "Error: #{e.message}"
  end
end

# RoleRepository 负责角色数据操作
class RoleRepository
  def initialize(storage)
    @storage = storage
  end

  def create_role(name)
    role = Role.new(id: SecureRandom.uuid, name: name)
    @storage << role
    role
  rescue => e
    handle_error(e)
  end

  private
  def handle_error(e)
    # 错误处理逻辑
    puts "Error: #{e.message}"
  end
end

# UserService 提供用户权限管理业务逻辑
class UserService
  attr_reader :user_repository, :role_repository

  def initialize(user_repository, role_repository)
    @user_repository = user_repository
    @role_repository = role_repository
  end

  def create_user_with_role(name, role_name)
    role = role_repository.create_role(role_name)
    user_repository.create_user(name, [role.id])
  end
end

# 存储示例，实际应用中应替换为数据库
class Storage
  include Enumerable

  attr_accessor :data

  def initialize
    @data = []
  end

  def each(&blk)
    data.each(&blk)
  end

  def <<(entity)
    data << entity
  end
end

# 应用程序示例
if __FILE__ == $0
  storage = Storage.new
  user_repository = UserRepository.new(storage)
  role_repository = RoleRepository.new(storage)
  user_service = UserService.new(user_repository, role_repository)

  # 创建角色
  role = role_repository.create_role("admin")
  puts "Role created: #{role.name}"

  # 创建用户
  user = user_service.create_user_with_role("Alice", "admin")
  puts "User created: #{user.name} with role: #{user.role_ids.first}"
end