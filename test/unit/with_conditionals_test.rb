$:.unshift File.dirname(__FILE__) + '/..'
require 'test_helper'

class WithConditionalsTest < ActiveSupport::TestCase
  def test_should_not_encrypt_if_if_conditional_is_false
    User.encrypts :password, :if => lambda { |user| false }
    user = User.create! :login => 'admin', :password => 'secret'
    assert_equal 'secret', user.password
  end
  
  def test_should_encrypt_if_if_conditional_is_true
    User.encrypts :password, :if => lambda { |user| true }
    user = User.create! :login => 'admin', :password => 'secret'
    assert_equal '8152bc582f58c854f580cb101d3182813dec4afe', "#{user.password}"
  end
  
  def test_should_not_encrypt_if_unless_conditional_is_true
    User.encrypts :password, :unless => lambda { |user| true }
    user = User.create! :login => 'admin', :password => 'secret'
    assert_equal 'secret', user.password
  end
  
  def test_should_encrypt_if_unless_conditional_is_false
    User.encrypts :password, :unless => lambda { |user| false }
    user = User.create! :login => 'admin', :password => 'secret'
    assert_equal '8152bc582f58c854f580cb101d3182813dec4afe', "#{user.password}"
  end
end
