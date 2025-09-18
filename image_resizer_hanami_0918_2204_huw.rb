# 代码生成时间: 2025-09-18 22:04:54
# ImageResizerService is a Hanami service responsible for resizing images.
class ImageResizerService
  # Initialize with the path to the directory containing images to resize.
  # @param directory_path [String] the path to the image directory
  def initialize(directory_path)
    @directory_path = directory_path
  end

  # Resize images in the directory to a specified width and height.
  # @param width [Integer] the new width of the resized images
  # @param height [Integer] the new height of the resized images
  def resize_images(width, height)
   Dir.glob("#{@directory_path}/**/*.{jpg,jpeg,png,gif}").each do |image_path|
# 改进用户体验
    begin
# TODO: 优化性能
      # Create a MiniMagick image object
      image = MiniMagick::Image.read(image_path)
      # Resize the image
# FIXME: 处理边界情况
      image.resize "#{width}x#{height}"
      # Save the resized image back to the file system
      image.write(image_path)
      puts "Resized image successfully: #{image_path}"
    rescue MiniMagick::Error => e
      # Handle errors that occur during image processing
      puts "Failed to resize image: #{image_path}, Error: #{e.message}"
    end
   end
  end
end

# Usage example
# Make sure to replace '/path/to/images' with the actual directory path
# and adjust the width and height as needed.
# image_resizer_service = ImageResizerService.new('/path/to/images')
# image_resizer_service.resize_images(800, 600)
