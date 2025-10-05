# 代码生成时间: 2025-10-06 02:52:31
# frozen_string_literal: true

# This file is part of the Hanami framework.
#
# @copyright 2016-2023 Woody Gilk
# @author Woody Gilk <woody.gilk@gmail.com>

# Neural Network Service using Hanami
class NeuralNetworkService
  # Initialize the Neural Network Service
  #
  # @param input_size [Integer] The number of neurons in the input layer
  # @param hidden_size [Integer] The number of neurons in the hidden layer
  # @param output_size [Integer] The number of neurons in the output layer
  def initialize(input_size, hidden_size, output_size)
    @input_size = input_size
    @hidden_size = hidden_size
    @output_size = output_size
    @weights_input_to_hidden = Array.new(@input_size * @hidden_size) { rand(-1..1) }
    @weights_hidden_to_output = Array.new(@hidden_size * @output_size) { rand(-1..1) }
    @bias_hidden = Array.new(@hidden_size) { rand(-1..1) }
    @bias_output = Array.new(@output_size) { rand(-1..1) }
  end

  # Train the Neural Network
  #
  # @param inputs [Array] The input data for training
  # @param outputs [Array] The expected output data for training
  def train(inputs, outputs)
    raise ArgumentError, 'Inputs and Outputs must be arrays' unless inputs.is_a?(Array) && outputs.is_a?(Array)
    raise ArgumentError, 'Inputs and Outputs must have the same length' unless inputs.length == outputs.length

    inputs.each_with_index do |input, i|
      hidden_layer_inputs = @input_size.times.map { |j| input[j] * @weights_input_to_hidden[j] }
      hidden_layer_outputs = sigmoid(sum(hidden_layer_inputs) + @bias_hidden)
      output_layer_inputs = @hidden_size.times.map { |j| hidden_layer_outputs[j] * @weights_hidden_to_output[j] }
      final_outputs = sigmoid(sum(output_layer_inputs) + @bias_output)

      # Calculate errors
      hidden_errors = outputs[i].zip(final_outputs).map { |expected, actual| (expected - actual) * derivative_sigmoid(actual) }
      output_errors = outputs[i].zip(final_outputs).map { |expected, actual| (expected - actual) * derivative_sigmoid(actual) }

      # Update weights
      @weights_hidden_to_output = update_weights(@weights_hidden_to_output, hidden_layer_outputs, hidden_errors)
      @weights_input_to_hidden = update_weights(@weights_input_to_hidden, input, output_errors)

      # Update biases
      @bias_hidden = update_biases(@bias_hidden, hidden_errors)
      @bias_output = update_biases(@bias_output, output_errors)
    end
  end

  private

  # Sigmoid function for the activation of neurons
  def sigmoid(x)
    1 / (1 + Math.exp(-x))
  end

  # Derivative of the sigmoid function
  def derivative_sigmoid(x)
    x * (1 - x)
  end

  # Sum elements of an array
  def sum(array)
    array.sum
  end

  # Update weights based on the learning algorithm
  def update_weights(weights, inputs, errors, learning_rate = 0.5)
    weights.zip(inputs).zip(errors).map do |(weight, input, error)|
      weight + (learning_rate * error * input)
    end
  end

  # Update biases based on the learning algorithm
  def update_biases(biases, errors, learning_rate = 0.5)
    biases.zip(errors).map do |bias, error|
      bias + (learning_rate * error)
    end
  end
end
