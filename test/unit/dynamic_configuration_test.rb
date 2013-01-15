$:.unshift File.dirname(__FILE__) + '/..'
require 'test_helper'

class DynamicConfigurationTest < ActiveSupport::TestCase
  def setup
    @salt = nil
    before_callback = Proc.new { |user| user.salt = user.login }

    User.encrypts :password, :before => before_callback do |user|
      { :salt => @salt = user.salt }
    end
    
    @user = User.create! :login => 'admin', :password => 'secret'
  end
  
  def test_should_use_dynamic_configuration_during_write
    assert_equal 'a55d037f385cad22efe7862e07b805938d150154', @user.password
  end
  
  def test_should_use_dynamic_configuration_during_read
    user = User.find @user.id
    assert_equal 'a55d037f385cad22efe7862e07b805938d150154', @user.password
  end
  
  def test_should_build_configuration_after_before_callbacks_invoked
    assert_equal 'admin', @salt
  end

  def teardown
    User.reset_callbacks :encrypt_password
  end
end
