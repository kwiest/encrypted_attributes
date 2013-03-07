$:.unshift File.dirname(__FILE__) + '/..'
require 'test_helper'

class SymmetricEncryptionTest < ActiveSupport::TestCase
  def setup
    User.encrypts :password, :mode => :symmetric, :password => 'key'

    @user = User.create! :login => 'admin', :password => 'secret'
  end
  
  def test_should_encrypt_password
    assert_equal "zfKtnSa33tc=\n", @user.password
  end
  
  def test_should_be_encrypted
    assert @user.password.encrypted?
  end
  
  def test_should_use_sha_cipher
    assert_instance_of EncryptedStrings::SymmetricCipher, @user.password.cipher
  end
  
  def test_should_use_custom_password
    assert_equal 'key', @user.password.cipher.password
  end
  
  def test_should_be_able_to_check_password
    assert_equal 'secret', @user.password
  end

  def teardown
    User.reset_callbacks :encrypt_password
    super
  end
end
