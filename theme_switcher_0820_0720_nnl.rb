# 代码生成时间: 2025-08-20 07:20:35
# theme_switcher.rb
#
# This file contains a simple theme switcher using Ruby and Hanami framework.
# It demonstrates how to structure a program, handle errors,
# and provide documentation and comments for maintainability and extensibility.

require 'hanami'
require 'hanami/controller'
require 'hanami/helpers'
require 'hanami/model'
require 'hanami/validations'
require 'hanami/repository'
require 'hanami/storage'

# Define a User entity
class User
  include Hanami::Entity

  attributes :id, :name, :theme
end

# Define a UserRepository
class UserRepository < Hanami::Repository
  def initialize
    super(User)
  end
end

# Define a ThemeValidator
class ThemeValidator < Hanami::Validations::Form
  attribute :theme, String
  validates :theme, presence: true, inclusion: { in: ['light', 'dark'] }
end

# Define a ThemeService
class ThemeService
  def initialize(user_repository, theme_validator)
    @user_repository = user_repository
    @theme_validator = theme_validator
  end

  # Switches the user's theme
  def switch_theme(user_id, theme)
    unless @theme_validator.call(theme).valid?
      raise 'Invalid theme'
    end
    @user_repository.by_id(user_id).update(theme: theme)
  rescue Hanami::Repository::RecordNotFound
    raise 'User not found'
  end
end

# Define a ThemeSwitcherController
class ThemeSwitcherController < Hanami::Controller
  include Hanami::Helpers
  include Hanami::Controller::Action::Flash
  include Hanami::Action::Cookies

  def switch
    user_id = params.fetch(:id)
    theme = params.fetch(:theme)

    begin
      theme_service = ThemeService.new(UserRepository.new, ThemeValidator.new)
      theme_service.switch_theme(user_id, theme)
      flash.now[:success] = 'Theme switched successfully!'
    rescue => e
      flash.now[:error] = e.message
    end

    redirect_to '/success'
  end

  private

  # Helper method to get the user repository
  def user_repository
    @user_repository ||= UserRepository.new
  end

  # Helper method to get the theme validator
  def theme_validator
    @theme_validator ||= ThemeValidator.new
  end
end

# Define a SuccessAction
class SuccessAction < Hanami::Action
  def call(input)
    self.body = 'Theme switch was successful!'
  end
end
