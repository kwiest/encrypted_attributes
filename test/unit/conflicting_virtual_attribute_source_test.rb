$:.unshift File.dirname(__FILE__) + '/..'
require 'test_helper'

class ConflictingVirtualAttributeSourceTest < ActiveSupport::TestCase
  def setup
    User.class_eval do
      def raw_password
        'raw_password'
      end

      def raw_password=(value)
        self.password = value
      end
    end

    User.encrypts :raw_password, :to => :crypted_password

    @user = User.new
  end

  def test_should_not_define_source_reader
    assert_equal 'raw_password', @user.raw_password
  end
  
  def test_should_not_define_source_writer
    @user.raw_password = 'raw_password'
    assert_equal 'raw_password', @user.password
  end

  def teardown
    User.class_eval do
      reset_callbacks :encrypt_raw_password
      remove_method :raw_password
      remove_method :raw_password=
    end
    super
  end
end
