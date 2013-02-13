$:.unshift File.dirname(__FILE__) + '/..'
require 'test_helper'

class BeforeCallbacksTest < ActiveSupport::TestCase
  def setup
    User.class_eval do
      attr_reader :password_var, :ran_callback

      encrypts :password, :before => lambda {
        @password_var = password
        @ran_callback = true
      }

      def initialize(*args)
        @password_var = nil
        @ran_callback = false
        super
      end
    end

    @user = User.create! :login => 'admin', :password => 'secret'
  end
  
  def test_should_run_callback
    assert @user.ran_callback
  end
  
  def test_should_not_have_encrypted_yet
    assert_equal 'secret', @user.password_var
  end

  def teardown
    @user.instance_eval do
      remove_instance_variable :@password_var
      remove_instance_variable :@ran_callback
    end

    User.class_eval do
      reset_callbacks :encrypt_password
      undef_method :password_var, :ran_callback
    end
  end
end
