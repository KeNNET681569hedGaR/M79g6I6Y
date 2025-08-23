# 代码生成时间: 2025-08-23 11:13:30
# 防止SQL注入的HANAMI框架程序
# 遵循Ruby最佳实践和代码规范

require 'hanami/model'
require 'hanami/model/sql/adapters/postgres'
require 'hanami/model/sql/criteria'

# 配置数据库连接
adapter = Hanami::Model::Sql::Adapters::Postgres.new('database_url')
container = Hanami::Model::Container.new(adapter)

# 定义一个User模型
class User < Hanami::Model
  # 表名
  self.table_name = 'users'

  # 字段
  attribute :id, Integer
  attribute :name, String
  attribute :email, String
end

# Service类，用于业务逻辑
class UserService
  # 初始化数据库容器
  def initialize(container)
    @container = container
  end

  # 创建用户
  def create_user(name, email)
    # 使用参数化查询防止SQL注入
    query = 'INSERT INTO users (name, email) VALUES (?, ?) RETURNING *'
    params = [name, email]

    # 执行插入操作
    result = @container.query(query, *params)
    if result.empty?
      raise 'Failed to create user'
    else
      return result.first
    end
  end

  # 获取用户列表
  def get_users
    # 使用Criteria API构建查询
    users = @container.repository(:users)
    users = users.order(:id)

    # 获取数据
    users.to_a
  end

  # 更新用户信息
  def update_user(user_id, name, email)
    # 使用参数化查询防止SQL注入
    query = 'UPDATE users SET name = ?, email = ? WHERE id = ?'
    params = [name, email, user_id]

    # 执行更新操作
    result = @container.query(query, *params)
    if result.cmd_tuples == 0
      raise 'Failed to update user'
    else
      return result.cmd_tuples
    end
  end

  # 删除用户
  def delete_user(user_id)
    # 使用参数化查询防止SQL注入
    query = 'DELETE FROM users WHERE id = ?'
    params = [user_id]

    # 执行删除操作
    result = @container.query(query, *params)
    if result.cmd_tuples == 0
      raise 'Failed to delete user'
    else
      return result.cmd_tuples
    end
  end
end

# 错误处理和程序入口
if __FILE__ == $0
  container = Hanami::Model::Container.new(Hanami::Model::Sql::Adapters::Postgres.new('database_url'))
  service = UserService.new(container)

  # 测试创建用户
  begin
    user = service.create_user('Alice', 'alice@example.com')
    puts 'User created: ' + user.inspect
  rescue => e
    puts 'Error: ' + e.message
  end

  # 测试获取用户列表
  users = service.get_users
  puts 'Users: ' + users.inspect

  # 测试更新用户信息
  begin
    updated_count = service.update_user(1, 'Bob', 'bob@example.com')
    puts 'Updated users: ' + updated_count.to_s
  rescue => e
    puts 'Error: ' + e.message
  end

  # 测试删除用户
  begin
    deleted_count = service.delete_user(1)
    puts 'Deleted users: ' + deleted_count.to_s
  rescue => e
    puts 'Error: ' + e.message
  end
end