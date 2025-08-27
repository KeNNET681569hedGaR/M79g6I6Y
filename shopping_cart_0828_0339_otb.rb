# 代码生成时间: 2025-08-28 03:39:27
# encoding: utf-8
# Shopping cart implementation using the Hanami framework
#
# @author Your Name
# @version 1.0

require 'hanami'
require 'hanami/model' # Include Hanami::Model
require 'hanami/model/mapper' # Include Hanami::Model::Mapper

# Define a Product model
class Product
  include Hanami::Entity

  attributes :id, :name, :price
end

# Define a CartItem model
class CartItem
  include Hanami::Entity

  attributes :cart_id, :product_id, :quantity
end

# Define a Cart model
class Cart
  include Hanami::Entity
  include Hanami::Model::Mapper::Entity::ActiveRecord::Associations

  attributes :id
  associations do
    has_many :cart_items, through: :cart_items
  end
end

# Define a CartItemRepository for domain operations
class CartItemRepository
  include Hanami::Repository
  include Hanami::Repository::Callbacks::ActiveRecord

  def add_item(cart_id, product_id, quantity)
    cart_item = CartItem.new(cart_id: cart_id, product_id: product_id, quantity: quantity)
    if cart_item.save
      "Item added to cart successfully."
    else
      "Unable to add item to cart."
    end
  end

  def remove_item(cart_item_id)
    cart_item = CartItem.by_id(cart_item_id).first
    if cart_item && cart_item.destroy
      "Item removed from cart successfully."
    else
      "Unable to remove item from cart."
    end
  end
end

# Define a CartService for business logic
class CartService
  def initialize(repo)
    @repo = repo
  end

  # Adds an item to the cart
  #
  # @param cart_id [Integer] ID of the cart
  # @param product_id [Integer] ID of the product to add
  # @param quantity [Integer] Quantity of the product to add
  # @return [String] Success or error message
  def add_product_to_cart(cart_id, product_id, quantity)
    unless cart_id && product_id && quantity
      return "Invalid parameters provided."
    end

    result = @repo.add_item(cart_id, product_id, quantity)
    result
  end

  # Removes an item from the cart
  #
  # @param cart_item_id [Integer] ID of the cart item to remove
  # @return [String] Success or error message
  def remove_product_from_cart(cart_item_id)
    unless cart_item_id
      return "Invalid parameters provided."
    end

    result = @repo.remove_item(cart_item_id)
    result
  end
end

# Define a controller for the shopping cart
class ShoppingCartController < Hanami::Controller
  include Hanami::Action::RenderView
  include Hanami::Action::Params
  include Hanami::Action::Cookies
  include Hanami::Action::Flash
  include Hanami::Action::Session
  include Hanami::Action::CsrfProtection
  include Hanami::Action::Helpers::UrlHelper

  # Handle adding a product to the cart
  #
  # @route POST /cart/:cart_id/add/:product_id
  def add
    cart_id = params[:cart_id].to_i
    product_id = params[:product_id].to_i
    quantity = params[:quantity].to_i

    result = CartService.new(CartItemRepository.new).add_product_to_cart(cart_id, product_id, quantity)
    flash[:notice] = result
    redirect_to url(:carts, action: :show, id: cart_id)
  end

  # Handle removing a product from the cart
  #
  # @route POST /cart/:cart_id/remove/:cart_item_id
  def remove
    cart_item_id = params[:cart_item_id].to_i

    result = CartService.new(CartItemRepository.new).remove_product_from_cart(cart_item_id)
    flash[:notice] = result
    redirect_to url(:carts, action: :show, id: params[:cart_id].to_i)
  end
end