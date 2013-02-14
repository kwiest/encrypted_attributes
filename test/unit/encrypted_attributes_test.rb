$:.unshift File.dirname(__FILE__) + '/..'
require 'test_helper'

class EncryptedAttributesTest < ActiveSupport::TestCase
  def setup
    User.encrypts :password
  end
  
  def test_should_use_sha_by_default
    user = User.create! :login => 'admin', :password => 'secret'
    assert_equal '8152bc582f58c854f580cb101d3182813dec4afe', "#{user.password}"
  end
  
  def test_should_encrypt_on_invalid_model
    user = User.new :login => nil, :password => 'secret'
    assert !user.valid?
    assert_equal '8152bc582f58c854f580cb101d3182813dec4afe', "#{user.password}"
  end
  
  def test_should_not_encrypt_if_attribute_is_nil
    user = User.create! :login => 'admin', :password => nil
    assert_nil user.password
  end
  
  def test_should_not_encrypt_if_attribute_is_blank
    user = User.create! :login => 'admin', :password => ''
    assert_equal '', user.password
  end
  
  def test_should_not_encrypt_if_already_encrypted
    user = User.create! :login => 'admin', :password => 'secret'.encrypt
    assert_equal '8152bc582f58c854f580cb101d3182813dec4afe', "#{user.password}"
  end
  
  def test_should_return_encrypted_attribute_for_saved_record
    user = User.create! :login => 'admin', :password => 'secret'
    user = User.find(user.id)
    assert user.password.encrypted?
    assert_equal '8152bc582f58c854f580cb101d3182813dec4afe', "#{user.password}"
  end
  
  def test_should_not_encrypt_attribute_if_updating_without_any_changes
    user = User.create! :login => 'admin', :password => 'secret'
    user.login = 'Administrator'
    user.save!
    assert user.password.encrypted?
    assert_equal '8152bc582f58c854f580cb101d3182813dec4afe', "#{user.password}"
  end
  
  def test_should_encrypt_attribute_if_updating_with_changes
    user = User.create! :login => 'admin', :password => 'secret'
    user.password = 'shhh'
    user.save!
    assert user.password.encrypted?
    assert_equal '162cf5debf84cbc2af13da848544c3e2c515b4d3', "#{user.password}"
  end
  
  def teardown
    User.reset_callbacks :encrypt_password
    super
  end
end

