# 代码生成时间: 2025-08-14 13:09:46
# shopping_cart.rb
# This file represents a simple shopping cart implementation using Ruby and Hanami framework.

require 'hanami'
require 'hanami/model'
require 'hanami/model/rspec'

# Cart class represents a shopping cart with basic operations.
class Cart
  include Hanami::Entity
  include Hanami::Model::Timestamps

  # Attributes
  attribute :id, Integer
  attribute :total_items, Integer, default: 0
  attribute :total_price, BigDecimal, default: 0.0
  attribute :user_id, Integer

  # Associations
  has_many :items, CartItem

  # Validation
  validations do
    validates_presence :total_items
    validates_presence :total_price
    validates_presence :user_id
  end

  # Adds an item to the cart with the given price and quantity.
  #
  # @param item [CartItem] The item to be added to the cart.
  # @return [void]
  def add_item(item)
    items << item
    update_total
  end

  # Removes an item from the cart.
  #
  # @param item_id [Integer] The ID of the item to be removed from the cart.
  # @return [void]
  def remove_item(item_id)
    item = items.find(item_id)
    item.destroy if item
    update_total
  end

  # Updates the total price and total items count based on the current items in the cart.
  #
  # @return [void]
  def update_total
    self.total_items = items.count
    self.total_price = items.sum(&:price)
  end
end

# CartItem class represents an item within a shopping cart.
class CartItem
  include Hanami::Entity
  include Hanami::Model::Timestamps

  # Attributes
  attribute :id, Integer
  attribute :quantity, Integer, default: 1
  attribute :price, BigDecimal
  attribute :cart_id, Integer

  # Associations
  belongs_to :cart, Cart

  # Validation
  validations do
    validates_presence :quantity
    validates_presence :price
    validates_presence :cart_id
  end
end