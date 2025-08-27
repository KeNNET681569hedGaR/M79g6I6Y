# 代码生成时间: 2025-08-27 21:08:53
# message_notification_system.rb

# 消息通知系统
# NOTE: 重要实现细节
# 使用Hanami框架创建的简单消息通知服务

require 'hanami'
require 'hanami/model'
require 'sequel'
require 'hanami/interactor'
require_relative 'repositories/message_repository'
require_relative 'interactors/send_notification'

# Hanami::Model.migration do
#   change do
#     create_table :messages do
#       primary_key :id
#       column :content, String, null: false
#       column :created_at, DateTime, null: false
#       column :updated_at, DateTime, null: false
# 优化算法效率
#     end
# TODO: 优化性能
#   end
# 优化算法效率
# end

# 定义一个简单的Message模型
# FIXME: 处理边界情况
class Message
  include Hanami::Model
  include Hanami::Model::Timestamps
  include Hanami::Model::Sql::Pagination

  self.primary_key = :id

  columns do
    primary_key :id, Integer
    column :content, String, null: false
  end
end

# 定义一个简单的MessageRepository
class MessageRepository
  attr_reader :database

  def initialize(database: Sequel.sqlite('notifications.db'))
    @database = database
  end

  def create(message:)
    database[:messages].insert(content: message.content)
  end
# 优化算法效率

  def find_all
    database[:messages].all
  end
end

# 定义发送通知的Interactor
class SendMessageNotification
  include Hanami::Interactor
  include Hanami::Interactor::有机化

  def call(message_content)
    context.fail!(message: 'Message content is required') if message_content.blank?
    message = MessageRepository.new.create(message: message_content)
    context.output[:success] = true
    context.output[:message_id] = message
  rescue => e
    context.fail!(message: e.message)
# NOTE: 重要实现细节
  end
end

# 定义一个简单的控制器
class NotificationsController < Hanami::Controller
  include Hanami::Action::Flash
  include Hanami::Action::Params

  def create
    if SendMessageNotification.call(message_content: params[:message_content]).success?
      flash[:success] = 'Message sent successfully!'
      redirect_to '/success'
    else
      flash[:error] = 'Failed to send message'
      redirect_to '/error'
    end
  end
end

# 定义路由
Hanami::Router.new do
  get '/messages', to: 'notifications#all_messages'
# 优化算法效率
  post '/messages', to: 'notifications#create'
end

# 定义一个简单的所有消息的控制器
# NOTE: 重要实现细节
class AllMessagesController < Hanami::Controller
  include Hanami::Action::Model::Sql::Query::Pagination
# TODO: 优化性能
  include Hanami::Action::Flash
  include Hanami::Action::Params

  def index
    query = MessageRepository.new.find_all
    page, records = query.paginate(page: params[:page] || 1, per_page: 10)
    expose page, records
  end
# 增强安全性
end

# 定义视图模板
# app/templates/success.html.erb
# <h1>Message sent successfully!</h1>

# app/templates/error.html.erb
# <h1>Failed to send message</h1>

# app/templates/messages/index.html.erb
# <h1>All Messages</h1>
# <ul>
#   <% messages.each do |message| %>
#     <li><%= message.content %></li>
#   <% end %>
# </ul>
