# 代码生成时间: 2025-09-08 15:32:12
# theme_switcher.rb
#
# This program demonstrates a theme switching feature using Ruby and Hanami framework.
# It includes error handling, documentation, and follows Ruby best practices for maintainability and extensibility.

require 'hanami'
require 'hanami/helpers'
require 'hanami/model'

# Define a User entity to manage user data
class User
  include Hanami::Entity
end

# Define a UserRepository for data persistence
class UserRepository < Hanami::Repository
end

# Define a Theme entity to manage theme data
class Theme
  include Hanami::Entity
end

# Define a ThemeRepository for data persistence
class ThemeRepository < Hanami::Repository
end

# Define a ThemeService to handle theme switching logic
class ThemeService
  # Initialize with a user_id and theme_id
  def initialize(user_id, theme_id)
    @user_id = user_id
    @theme_id = theme_id
  end

  # Switch theme for a given user
  def switch_theme
    user = UserRepository.new.find(@user_id)
    return { error: 'User not found' } unless user

    theme = ThemeRepository.new.find(@theme_id)
    return { error: 'Theme not found' } unless theme

    begin
      # Update user's theme preference
      user.update(theme: theme.name)
      UserRepository.new.commit(user)
      { success: 'Theme switched successfully', current_theme: user.theme.name }
    rescue StandardError => e
      { error: e.message }
    end
  end
end

# Define a controller to handle incoming HTTP requests
class ThemeController < Hanami::Controller
  include Hanami::Helpers::Http::UrlHelper
  include Hanami::Helpers::Http::FlashHelper
  include Hanami::Helpers::Http::FormHelper
  include Hanami::Helpers::Http::SessionHelper

  # GET /theme/:id - Show current theme or error
  get '/theme/:id' do
    theme_id = params.fetch(:id)
    theme = ThemeRepository.new.find(theme_id)
    halt 404, json: { error: 'Theme not found' } unless theme

    json: { theme: theme.name }
  end

  # POST /theme/switch - Switch user's theme
  post '/theme/switch' do
    theme_id = params.fetch(:theme_id)
    user_id = session.fetch(:user_id)
    service = ThemeService.new(user_id, theme_id)
    result = service.switch_theme

    if result.key?(:error)
      flash.now[:error] = result[:error]
    else
      flash.now[:success] = result[:success]
    end

    json: result
  end
end
