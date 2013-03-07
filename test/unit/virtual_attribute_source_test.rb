$:.unshift File.dirname(__FILE__) + '/..'
require 'test_helper'

class EncryptedAttributesWithVirtualAttributeSourceTest < ActiveSupport::TestCase
  def setup
    User.encrypts :raw_password, :to => :crypted_password
  end

  def test_should_define_source_reader
    assert User.method_defined?(:raw_password)
  end
  
  def test_should_define_source_writer
    assert User.method_defined?(:raw_password=)
  end
  
  def test_should_encrypt_from_virtual_attribute
    user = User.create! :login => 'admin', :raw_password => 'secret'
    assert user.crypted_password.encrypted?
    assert_equal '8152bc582f58c854f580cb101d3182813dec4afe', user.crypted_password
  end

  def teardown
    User.reset_callbacks :encrypt_raw_password
    super
  end
end
