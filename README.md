# encrypted_attributes

[![Build Status](https://travis-ci.org/kwiest/encrypted_attributes.png)](https://travis-ci.org/kwiest/encrypted_attributes)

`encrypted_attributes` adds support for automatically encrypting ActiveRecord
attributes.

# Description

Encrypting attributes can be repetitive especially when doing so throughout
various models and various projects.  `encrypted_attributes`, in association
with the `encrypted_strings` library, helps make encrypting ActiveRecord
attributes easier by automating the process.

The options that +encrypts+ takes includes all of the encryption options for
the specific type of cipher being used from the `encrypted_strings` library.
Therefore, if setting the key for asymmetric encryption, this would be passed
into the +encrypts+ method.  Examples of this are show in the Usage section.

## Usage

### Encryption Modes

SHA, symmetric, and asymmetric encryption modes are supported (default is SHA):

```ruby
class User < ActiveRecord::Base
  encrypts :password, :salt => 'secret'
  # encrypts :password, :mode => :symmetric, :password => 'secret'
  # encrypts :password, :mode => :asymmetric, :public_key_file => '/keys/public', :private_key_file => '/keys/private'
end
```

### Dynamic Configuration

The encryption configuration can be dynamically set like so:

```ruby
class User < ActiveRecord::Base
  encrypts :password, :mode => :sha do |user|
    {:salt => "#{user.login}-#{Time.now}", :embed_salt => true}
  end
end
```

In this case, the salt and password values are combined and stored in the
attribute being encrypted.  Therefore, there's no need to add a second column
for storing the salt value.

To store the dynamic salt in a separate column:

```ruby
class User < ActiveRecord::Base
  encrypts :password, :mode => :sha, :before => :create_salt do |user|
    {:salt => user.salt}
  end
  
  def create_salt
    self.salt = "#{login}-#{Time.now}"
  end
end
```

### Targeted Encryption

If you want to store the encrypted value in a different attribute than the
attribute being encrypted:

```ruby
class User < ActiveRecord::Base
  encrypts :password, :to => :crypted_password
end
```

### Conditional Encryption

Like ActiveRecord validations, `encrypts` can take `:if` and `:unless`
parameters that determine whether the encryption should occur.  For example,

```ruby
class User < ActiveRecord::Base
  encrypts :password, :if => lambda {Rails.env != 'development'}
end
```

### Additional information

For more examples of actual migrations and models that encrypt attributes,
see the actual API and unit tests.  Also, see `encrypted_strings` for more
information about the various options that can be passed in.

## Dependencies

* Rails 3.0 or later
* [encrypted_strings](http://github.com/pluginaweek/encrypted_strings)
