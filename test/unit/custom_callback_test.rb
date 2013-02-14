$:.unshift File.dirname(__FILE__) + '/..'
require 'test_helper'

class CustomCallbackTest < ActiveSupport::TestCase
  def setup
    User.encrypts :password, :on => :save
  end
  
  def test_should_not_encrypt_on_validation
    user = User.new :login => 'admin', :password => 'secret'
    user.valid?
    assert_equal 'secret', user.password
  end
  
  def test_should_encrypt_on_create
    user = User.new :login => 'admin', :password => 'secret'
    user.save
    assert_equal '8152bc582f58c854f580cb101d3182813dec4afe', "#{user.password}"
  end

  def teardown
    User.reset_callbacks :save
  end
end
