class User < ActiveRecord::Base
  validates :login, :presence => true
end
