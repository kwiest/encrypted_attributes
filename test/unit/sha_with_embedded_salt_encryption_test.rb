$:.unshift File.dirname(__FILE__) + '/..'
require 'test_helper'

class ShaWithEmbeddedSaltEncryptionTest < ActiveSupport::TestCase
  def setup
    User.encrypts :password, :mode => :sha, :salt => 'admin', :embed_salt => true

    @user = User.create! :login => 'admin', :password => 'secret'
  end
  
  def test_should_encrypt_password
    assert_equal 'a55d037f385cad22efe7862e07b805938d150154admin', "#{@user.password}"
  end
  
  def test_should_be_encrypted
    assert @user.password.encrypted?
  end
  
  def test_should_use_sha_cipher
    assert_instance_of EncryptedAttributes::ShaCipher, @user.password.cipher
  end
  
  def test_should_use_custom_salt
    assert_equal 'admin', @user.password.cipher.salt
  end
  
  def test_should_be_able_to_check_password
    assert_equal 'secret', @user.password
  end

  def teardown
    User.reset_callbacks :encrypt_password
    super
  end
end
