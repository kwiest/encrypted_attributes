$:.unshift File.dirname(__FILE__) + '/..'
require 'test_helper'

class MultipleAttributesTest < ActiveSupport::TestCase
  def setup
    User.encrypts :password, :password_reminder
  end
  
  def test_should_both_using_sha
    user = User.create! :login => 'admin', :password => 'secret', :password_reminder => 'shhh'
    assert_equal '8152bc582f58c854f580cb101d3182813dec4afe', "#{user.password}"
    assert_equal '162cf5debf84cbc2af13da848544c3e2c515b4d3', "#{user.password_reminder}"
  end
  
  def test_should_encrypt_on_invalid_model
    user = User.new :login => nil, :password => 'secret', :password_reminder => 'shhh'
    assert !user.valid?
    assert_equal '8152bc582f58c854f580cb101d3182813dec4afe', "#{user.password}"
    assert_equal '162cf5debf84cbc2af13da848544c3e2c515b4d3', "#{user.password_reminder}"
  end
  
  def test_should_not_encrypt_if_attributes_are_nil
    user = User.create! :login => 'admin', :password => nil, :password_reminder => nil
    assert_nil user.password
    assert_nil user.password_reminder
  end
  
  def test_should_not_encrypt_if_attributes_are_blank
    user = User.create! :login => 'admin', :password => '', :password_reminder => ''
    assert_equal '', user.password
    assert_equal '', user.password_reminder
  end
  
  def test_should_not_encrypt_any_if_already_encrypted
    user = User.create! :login => 'admin', :password => 'secret'.encrypt, :password_reminder => 'shhh'.encrypt
    assert_equal '8152bc582f58c854f580cb101d3182813dec4afe', "#{user.password}"
    assert_equal '162cf5debf84cbc2af13da848544c3e2c515b4d3', "#{user.password_reminder}"
  end
  
  def test_should_return_encrypted_attributes_for_saved_record
    user = User.create! :login => 'admin', :password => 'secret', :password_reminder => 'shhh'
    user = User.find user.id
    assert user.password.encrypted?
    assert_equal '8152bc582f58c854f580cb101d3182813dec4afe', "#{user.password}"
    
    assert user.password_reminder.encrypted?
    assert_equal '162cf5debf84cbc2af13da848544c3e2c515b4d3', "#{user.password_reminder}"
  end
  
  def test_should_not_encrypt_attributes_if_updating_without_any_changes
    user = User.create! :login => 'admin', :password => 'secret', :password_reminder => 'shhh'
    user.login = 'Administrator'
    user.save!
    assert user.password.encrypted?
    assert_equal '8152bc582f58c854f580cb101d3182813dec4afe', "#{user.password}"
    
    assert user.password_reminder.encrypted?
    assert_equal '162cf5debf84cbc2af13da848544c3e2c515b4d3', "#{user.password_reminder}"
  end
  
  def test_should_encrypt_attributes_if_updating_with_changes
    user = User.create! :login => 'admin', :password => 'secret', :password_reminder => 'shhh'
    user.password = 'shhh'
    user.password_reminder = 'secret'
    user.save!
    assert user.password.encrypted?
    assert_equal '162cf5debf84cbc2af13da848544c3e2c515b4d3', "#{user.password}"
    
    assert user.password_reminder.encrypted?
    assert_equal '8152bc582f58c854f580cb101d3182813dec4afe', "#{user.password_reminder}"
  end
end
