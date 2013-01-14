class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login
      t.string :password
      t.string :crypted_password
      t.string :salt
      t.string :password_reminder
    end
  end

  def self.down
    drop_table :users
  end
end
