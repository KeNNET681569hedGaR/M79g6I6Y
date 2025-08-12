# 代码生成时间: 2025-08-12 18:32:07
#!/usr/bin/env ruby

# image_resizer.rb
# This script is designed to resize multiple images to a specified dimension.

require 'hanami'
require 'mini_magick'
require 'dry-validation'
require 'dry-struct'
require 'fileutils'

# Define the schema for validation
class ImageResizerSchema < Dry::Validation::Contract
  config.messages.default_locale = :en

  params do
    required(:source).filled(:string)
    required(:destination).filled(:string)
    required(:width).filled(:integer)
    required(:height).filled(:integer)
  end
end

# Define the struct for holding the image resize parameters
class ImageResizerParams < Dry::Struct
  attribute :source, Types::String
  attribute :destination, Types::String
  attribute :width, Types::Integer
  attribute :height, Types::Integer
end

# Define the image resizer service
class ImageResizerService
  # Initialize the service with parameters
  attr_reader :params

  def initialize(params)
    @params = ImageResizerParams.new(params)
  end

  # Resize images in the source directory to the specified dimension and save to the destination directory
  def call
    return validate_and_resize if valid?
  end

  private

  # Validate the parameters using the schema
  def valid?
    ImageResizerSchema.new.call(@params.to_h).errors.empty?
  end

  # Process the resizing of images
  def validate_and_resize
    Dir.glob(File.join(@params.source, '*')).each do |file_path|
      begin
        image = MiniMagick::Image.open(file_path)
        image.resize("#{@params.width}x#{@params.height}!")
        image_path = File.join(@params.destination, File.basename(file_path))
        image.write(image_path)
        puts "Resized image saved to #{image_path}"
      rescue MiniMagick::Error => e
        puts "Failed to resize image: #{e.message}"
      end
    end
  end
end

# Usage example
if __FILE__ == $0
  # Example parameters
  source_dir = 'path/to/source/images'
  destination_dir = 'path/to/destination/images'
  width = 800
  height = 600

  # Create an instance of the service with the parameters
  service = ImageResizerService.new(source: source_dir, destination: destination_dir, width: width, height: height)
  # Call the service to resize images
  service.call
end