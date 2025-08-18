# 代码生成时间: 2025-08-19 04:19:56
# encoding: UTF-8

# PasswordManager is a tool for encrypting and decrypting passwords using Ruby and Hanami framework.
#
# It follows Ruby best practices, includes error handling, and is well-documented for maintainability and scalability.

require 'openssl'
require 'base64'

class PasswordManager
  # Initialize the class with a secret key for encryption and decryption
  def initialize(secret_key)
    @secret_key = secret_key
  end

  # Encrypts the provided password
  #
  # @param [String] password The password to encrypt
  # @return [String] The encrypted password
  def encrypt(password)
    raise 'Secret key is not set' unless @secret_key
    cipher = OpenSSL::Cipher.new('aes-256-cbc')
    cipher.encrypt
    cipher.key = @secret_key

    # Generate a random iv for each encryption to ensure security
    iv = cipher.random_iv
    # Encrypt the password
    encrypted_password = cipher.update(password) + cipher.final
    # Return the iv and the encrypted password, both base64 encoded
    "#{Base64.strict_encode64(iv)}:#{Base64.strict_encode64(encrypted_password)}"
  end

  # Decrypts the provided password
  #
  # @param [String] encrypted_password The encrypted password to decrypt, in the format of 'iv:encrypted'
  # @return [String] The decrypted password
  def decrypt(encrypted_password)
    raise 'Secret key is not set' unless @secret_key
    iv, encrypted = encrypted_password.split(':')
    iv = Base64.decode64(iv)
    encrypted = Base64.decode64(encrypted)

    cipher = OpenSSL::Cipher.new('aes-256-cbc')
    cipher.decrypt
    cipher.key = @secret_key
    cipher.iv = iv

    # Decrypt the password
    decrypted_password = cipher.update(encrypted) + cipher.final
    decrypted_password
  rescue OpenSSL::Cipher::CipherError
    # Handle decryption errors, e.g., wrong key or corrupted data
    'Decryption failed'
  end
end

# Example usage
if __FILE__ == $0
  secret_key = 'your_very_long_and_secure_secret_key'
  password_manager = PasswordManager.new(secret_key)

  original_password = 'my_secure_password'
  encrypted_password = password_manager.encrypt(original_password)
  puts "Encrypted: #{encrypted_password}"

  decrypted_password = password_manager.decrypt(encrypted_password)
  puts "Decrypted: #{decrypted_password}"
end
