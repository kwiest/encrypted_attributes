$:.unshift File.dirname(__FILE__) + '/..'
require 'test_helper'

class AsymmetricEncryptionTest < ActiveSupport::TestCase
  def setup
    User.encrypts :password, :mode => :asymmetric,
      :private_key_file => File.dirname(__FILE__) + '/../keys/private',
      :public_key_file => File.dirname(__FILE__) + '/../keys/public'

    @user = User.create! :login => 'admin', :password => 'secret'
  end
  
  def test_should_encrypt_password
    assert_not_equal 'secret', "#{@user.password}"
    assert_equal 90, @user.password.length
  end
  
  def test_should_be_encrypted
    assert @user.password.encrypted?
  end
  
  def test_should_use_sha_cipher
    assert_instance_of EncryptedStrings::AsymmetricCipher, @user.password.cipher
  end
  
  def test_should_be_able_to_check_password
    assert_equal 'secret', @user.password
  end

  def teardown
    User.reset_callbacks :validate
  end
end
