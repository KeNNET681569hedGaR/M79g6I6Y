# 代码生成时间: 2025-09-01 02:44:04
# Shopping Cart service
class ShoppingCart
  # Initialize the cart with an empty array of items
  def initialize
    @items = []
  end

  # Add an item to the cart
  # item: an instance of Item with attributes like name, price, and quantity
  def add_item(item)
    unless item.is_a?(Item)
      raise 'Invalid item type'
    end
    @items.push(item)
  end

  # Remove an item from the cart by index
  def remove_item(index)
    if index >= 0 && index < @items.size
      @items.delete_at(index)
    else
      raise 'Index out of bounds'
    end
  end

  # Get the total price of items in the cart
  def total_price
    @items.sum(&:price)
  end

  # Get the items in the cart
  def items
    @items
  end
end

# Item model
class Item
  attr_accessor :name, :price, :quantity

  def initialize(name, price, quantity)
    @name = name
    @price = price
    @quantity = quantity
  end
end

# Example usage
if __FILE__ == $0
  cart = ShoppingCart.new
  item1 = Item.new('Apple', 0.50, 3)
  item2 = Item.new('Banana', 0.20, 5)

  begin
    cart.add_item(item1)
    cart.add_item(item2)
    puts "Total price: \#{cart.total_price}"
  rescue StandardError => e
    puts "Error: \#{e.message}"
  end
end