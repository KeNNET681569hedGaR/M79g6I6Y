# 代码生成时间: 2025-10-01 22:53:43
# decision_tree_generator.rb
# This Hanami application generates decision trees based on provided data.
# The decision tree is a simple binary tree where each node
# represents a decision point and each leaf node represents a decision outcome.

require 'hanami'
require 'dry-types'

# Define a simple DecisionTree type using dry-types
class DecisionTree
  include Dry::Types[::Hash]
  # Define the structure of the decision tree node
  schema do
    required(:question).filled(:string) # The question or condition at this node
    optional(:yes).filled(:hash) # The 'yes' branch of the decision
    optional(:no).filled(:hash)   # The 'no' branch of the decision
  end
end

# DecisionTreeGenerator class responsible for generating a decision tree
class DecisionTreeGenerator
  # Initialize with a set of rules for the decision tree
  def initialize(rules)
    @rules = rules
  end

  # Generate a decision tree from the provided rules
  def generate
    raise 'Rules must be a non-empty array' if @rules.empty?

    DecisionTree.new(
      question: @rules.first[:question],
      yes: @rules.first[:yes] ? generate(@rules.first[:yes]) : nil,
      no: @rules.first[:no] ? generate(@rules.first[:no]) : nil
    )
  end

  private
  # Recursively generate the decision tree from the rules
  def generate(rules)
    return nil if rules.empty?
    DecisionTree.new(
      question: rules.first[:question],
      yes: rules.first[:yes] ? generate(rules.first[:yes]) : nil,
      no: rules.first[:no] ? generate(rules.first[:no]) : nil
    )
  end
end

# Example usage
if __FILE__ == $PROGRAM_NAME
  # Define the decision tree rules
  rules = [
    { question: "Is it raining?", yes: [
      { question: "Do you have an umbrella?", yes: ["Go home"], no: ["Buy an umbrella"] }
    ], no: [
      { question: "Do you need to go outside?", yes: ["Take a jacket"], no: ["Stay home"] }
    ] }
  ]

  # Create a decision tree generator and generate the tree
  generator = DecisionTreeGenerator.new(rules)
  tree = generator.generate
  puts tree.inspect
end