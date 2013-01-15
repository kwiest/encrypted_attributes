$:.unshift File.dirname(__FILE__) + '/..'
require 'test_helper'

class ShaEncryptionTest < ActiveSupport::TestCase
  def setup
    User.encrypts :password, :mode => :sha

    @user = User.create! :login => 'admin', :password => 'secret'
  end
  
  def test_should_encrypt_password
    assert_equal '8152bc582f58c854f580cb101d3182813dec4afe', "#{@user.password}"
  end
  
  def test_should_be_encrypted
    assert @user.password.encrypted?
  end
  
  def test_should_use_sha_cipher
    assert_instance_of EncryptedAttributes::ShaCipher, @user.password.cipher
  end
  
  def test_should_use_default_salt
    assert_equal 'salt', @user.password.cipher.salt
  end
  
  def test_should_be_able_to_check_password
    assert_equal 'secret', @user. password
  end
end
