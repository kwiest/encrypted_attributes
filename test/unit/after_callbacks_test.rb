$:.unshift File.dirname(__FILE__) + '/..'
require 'test_helper'

class EncryptedAttributesWithAfterCallbacksTest < MiniTest::Unit::TestCase
  def setup
    User.class_eval do
      attr_reader :password_var, :ran_callback

      def initialize(*args)
        @password_var = ''
        @ran_callback = false
        super
      end
    end

    callback = lambda { |record|
      @password_var = record.password
      @ran_callback = true
    }

    User.encrypts :password, :after => callback
    
    @user = User.create! :login => 'admin', :password => 'secret'
  end
  
  def test_should_run_callback
    assert @user.ran_callback, 'Callback should have been called'
  end
  
  def test_should_have_encrypted_already
    assert_equal '8152bc582f58c854f580cb101d3182813dec4afe', @user.password_var
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
