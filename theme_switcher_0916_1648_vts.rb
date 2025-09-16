# 代码生成时间: 2025-09-16 16:48:55
# theme_switcher.rb

# This class handles theme switching functionality within the Hanami application.
class ThemeSwitcher
  # This constant holds the available themes.
  # It can be extended with more themes as needed.
  AVAILABLE_THEMES = %w[dark light].freeze

  # Initialize the ThemeSwitcher with the current theme.
  # @param current_theme [String] The current theme set for the user.
  def initialize(current_theme)
    @current_theme = current_theme
  end

  # Switches the theme to the new theme if it's available.
  # @param new_theme [String] The new theme to switch to.
  # @return [String] The new theme if successfully switched, otherwise the error message.
  def switch(new_theme)
    if AVAILABLE_THEMES.include?(new_theme)
      @current_theme = new_theme
      "Theme switched to #{@current_theme}"
    else
      "Error: '#{new_theme}' is not an available theme."
    end
  end

  # Retrieves the current theme.
  # @return [String] The current theme.
  def current
    @current_theme
  end

  # Validates if a theme is available.
  # @param theme [String] The theme to validate.
  # @return [Boolean] True if the theme is available, false otherwise.
  def self.available?(theme)
    AVAILABLE_THEMES.include?(theme)
  end
end
