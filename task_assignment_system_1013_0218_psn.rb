# 代码生成时间: 2025-10-13 02:18:32
# 任务分配系统
# 使用汉米框架 (Hanami) 构建的简单任务分配应用程序

require 'hanami'
require 'hanami/model'
require 'hanami/repository'
require 'hanami/validations'
require 'hanami/action'

# 定义模型
module TaskAssignment
  module Model
    class Task < Hanami::Entity
      attributes :id, :name, :assigned_to, :status
    end
  end

  # 定义存储库
  module Repository
    class TaskRepository < Hanami::Repository
      def initialize(storage, mapping: Model::Task)
        super(storage, mapping)
      end
    end
  end

  # 定义验证器
  module Validations
    class TaskValidator < Hanami::Validations::Form
      attribute :name, String, presence: true, size?: { minimum: 3, maximum: 100 }
      attribute :assigned_to, String, presence: true, size?: { minimum: 3, maximum: 100 }
      attribute :status, String, presence: true, inclusion?: { in: ['pending', 'in_progress', 'completed'] }

      # 自定义验证逻辑
      validation do
        next if assigned_to.nil?
        if assigned_to != 'valid_user' # 假设的验证逻辑
          errors.add(:assigned_to, 'is not a valid user')
        end
      end
    end
  end

  # 定义控制器
  module Actions
    class CreateTask < Hanami::Action
      include Hanami::Action::Render
      include Hanami::Action::Session::Cookie
      include Hanami::Action::Flash

      def handle(req, res)
        @task = req.params[:task]
        @validator = Validations::TaskValidator.new(@task)

        if @validator.valid?
          task_repository = Repository::TaskRepository.new(storage: req.storage)
          task_repository.create(@task)
          res.flash.now[:success] = "Task created successfully"
        else
          res.flash.now[:error] = "Failed to create task: #{@validator.errors.to_sentence}"
        end

        res.redirect_to '/tasks'
      end
    end
  end
end

# 配置 Hanami 应用程序
Hanami.configure do
  mount TaskAssignment::Actions::CreateTask, at: '/tasks'
end

# 运行 Hanami 应用程序
Hanami::Utils::Runner.new.run!