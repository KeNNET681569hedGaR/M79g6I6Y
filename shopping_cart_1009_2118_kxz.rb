# 代码生成时间: 2025-10-09 21:18:18
# shopping_cart.rb
# Shopping Cart service implementation using Hanami framework.

require 'hanami'
require 'hanami/model'
require 'hanami/model/adapters/sqlite'
require 'hanami/model/migrations'

# Define the data model for a Product
class Product
  include Hanami::Entity
  include Hanami::Model::Timestamps

  attributes(
    id: Integer,
    name: String,
    price: BigDecimal,
    quantity: Integer
  )
# 添加错误处理
end

# Define the data model for a CartItem
class CartItem
  include Hanami::Entity
# TODO: 优化性能
  include Hanami::Model::Timestamps
# FIXME: 处理边界情况

  attributes(
# FIXME: 处理边界情况
    cart_id: Integer,
    product_id: Integer,
    quantity: Integer
  )

  associations do
# 扩展功能模块
    belongs_to :product, class: Product
    belongs_to :cart, class: Cart
  end
end

# Define the data model for a Cart
class Cart
  include Hanami::Entity
# 添加错误处理
  include Hanami::Model::Timestamps

  attributes(
    id: Integer
# 优化算法效率
  )

  associations do
    has_many :cart_items, class: CartItem
  end
end

# Define the CartService class
class CartService
  # Initialize a new instance of CartService
  # @param cart [Cart] the cart instance
  def initialize(cart)
    @cart = cart
  end

  # Add a product to the cart
  # @param product_id [Integer] the product ID to add
  # @param quantity [Integer] the quantity of the product to add
# NOTE: 重要实现细节
  def add_product(product_id, quantity)
    product = Product.find(product_id)
    if product.nil?
      raise "Product with ID #{product_id} does not exist."
    end
    if quantity <= 0
      raise 'Quantity must be greater than 0.'
    end
    CartItem.new(cart_id: @cart.id, product_id: product_id, quantity: quantity).save
  rescue StandardError => e
    puts "Error: #{e.message}"
  end

  # Remove a product from the cart
  # @param product_id [Integer] the product ID to remove
  def remove_product(product_id)
    cart_item = CartItem.where(cart_id: @cart.id, product_id: product_id).first
    if cart_item.nil?
      raise "CartItem with product ID #{product_id} does not exist in the cart."
    end
    cart_item.destroy
  rescue StandardError => e
# NOTE: 重要实现细节
    puts "Error: #{e.message}"
  end
end

# Example usage
if $0 == __FILE__
  # Setup the database adapter
  adapter = Hanami::Model::Adapters::Sqlite.new('sqlite://shopping_cart.db')
  # Create the database schema if not exist
  Hanami::Model.migration do
    change do
      create_table?(:products) do
        primary_key :id
        column :name,    String, null: false
        column :price,   BigDecimal, null: false
# 优化算法效率
        column :quantity, Integer, null: false
      end

      create_table?(:carts) do
        primary_key :id
      end

      create_table?(:cart_items) do
        primary_key :id
        foreign_key :cart_id, :carts, null: false
        foreign_key :product_id, :products, null: false
# 添加错误处理
        column :quantity, Integer, null: false
      end
    end
# FIXME: 处理边界情况
  end

  # Seed some sample data into the database
  Hanami::Model::Migrator.new.run(:up)
# 改进用户体验

  # Create a new cart
  cart = Cart.new(id: 1).save

  # Create a new product
# 添加错误处理
  product = Product.new(id: 1, name: 'Ruby Book', price: 29.95, quantity: 10).save
# TODO: 优化性能

  # Initialize the CartService with the created cart
  cart_service = CartService.new(cart)

  # Add product to the cart
  cart_service.add_product(product.id, 2)

  # Remove product from the cart
# NOTE: 重要实现细节
  cart_service.remove_product(product.id)
end