# 代码生成时间: 2025-08-26 02:32:51
# image_size_adjuster.rb
# This script resizes images to a specified width and height in a directory
# It follows Ruby best practices and is designed for maintainability and scalability

require 'hanami'
require 'mini_magick'
require 'fileutils'

# Error handling module for custom exceptions
module ImageSizeAdjusterErrors
  class FileNotFoundError < StandardError; end
  class ResizeError < StandardError; end
end

# ImageSizeAdjuster class to handle resizing images
class ImageSizeAdjuster
  # Initialize with directory path and target dimensions
  def initialize(directory, target_width, target_height)
    @directory = directory
    @target_width = target_width
    @target_height = target_height
  end

  # Resize all images in the directory
  def resize_images
    FileUtils.cd(@directory) do
      Dir.glob('*.{jpg,jpeg,png,gif}') do |image_file|
        begin
          puts "Processing #{image_file}"
          resize_image(File.basename(image_file))
        rescue => e
          puts "Error processing #{image_file}: #{e.message}"
        end
      end
    end
  end

  private

  # Resize a single image
  def resize_image(image_file)
    image = MiniMagick::Image.read(image_file)
    image.resize("#{@target_width}x#{@target_height}#")
    image.write(image_file)
    puts "Resized #{image_file}"
  rescue MiniMagick::Error => e
    raise ImageSizeAdjusterErrors::ResizeError, "Failed to resize #{image_file}: #{e.message}"
  end
end

# Usage example
begin
  # Specify the directory and target dimensions
  directory_path = '/path/to/images'
  target_width = 800
  target_height = 600

  # Create an instance of ImageSizeAdjuster
  adjuster = ImageSizeAdjuster.new(directory_path, target_width, target_height)

  # Resize images in the directory
  adjuster.resize_images
rescue ImageSizeAdjusterErrors::FileNotFoundError => e
  puts "Directory not found: #{e.message}"
rescue ImageSizeAdjusterErrors::ResizeError => e
  puts e.message
end
