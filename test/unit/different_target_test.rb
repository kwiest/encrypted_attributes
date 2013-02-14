$:.unshift File.dirname(__FILE__) + '/..'
require 'test_helper'

class DifferentTargetTest < ActiveSupport::TestCase
  def setup
    User.encrypts :password, :to => :crypted_password
  end
  
  def test_should_not_encrypt_if_attribute_is_nil
    user = User.create! :login => 'admin', :password => nil
    assert_nil user.password
    assert_nil user.crypted_password
  end
  
  def test_should_not_encrypt_if_attribute_is_blank
    user = User.create! :login => 'admin', :password => ''
    assert_equal '', user.password
    assert_nil user.crypted_password
  end
  
  def test_should_not_encrypt_if_already_encrypted
    user = User.create! :login => 'admin', :crypted_password => 'secret'.encrypt
    assert_equal '8152bc582f58c854f580cb101d3182813dec4afe', "#{user.crypted_password}"
  end
  
  def test_should_return_encrypted_attribute_for_saved_record
    user = User.create! :login => 'admin', :password => 'secret'
    user = User.find user.id
    assert user.crypted_password.encrypted?
    assert_equal '8152bc582f58c854f580cb101d3182813dec4afe', "#{user.crypted_password}"
  end
  
  def test_should_not_encrypt_attribute_if_updating_without_any_changes
    user = User.create! :login => 'admin', :password => 'secret'
    user.login = 'Administrator'
    user.save!
    assert user.crypted_password.encrypted?
    assert_equal '8152bc582f58c854f580cb101d3182813dec4afe', "#{user.crypted_password}"
  end
  
  def test_should_encrypt_attribute_if_updating_with_changes
    user = User.create! :login => 'admin', :password => 'secret'
    user.password = 'shhh'
    user.save!
    assert user.crypted_password.encrypted?
    assert_equal '162cf5debf84cbc2af13da848544c3e2c515b4d3', "#{user.crypted_password}"
  end
end
