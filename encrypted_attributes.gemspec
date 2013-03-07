$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'encrypted_attributes/version'

Gem::Specification.new do |s|
  s.name              = 'encrypted_attributes'
  s.version           = EncryptedAttributes::VERSION
  s.authors           = ['Kyle Wiest', 'Aaron Pfeifer']
  s.email             = 'kyle.wiest@gmail.com'
  s.description       = 'Adds support for automatically encrypting ActiveRecord attributes'
  s.summary           = 'Encrypts ActiveRecord attributes'
  s.require_paths     = ['lib']
  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- test/*`.split("\n")
  s.rdoc_options      = %w(--line-numbers --inline-source --title encrypted_attributes --main README.rdoc)
  s.extra_rdoc_files  = %w(README.rdoc CHANGELOG.rdoc LICENSE)
  
  s.add_dependency 'encrypted_strings', '>= 0.3.3'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rails', '>= 3.0.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'sqlite3'
end
