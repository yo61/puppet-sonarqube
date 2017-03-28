# This file is managed centrally by modulesync
#   https://github.com/maestrodev/puppet-modulesync

source ENV['GEM_SOURCE'] || "https://rubygems.org"

ENV['PUPPET_VERSION'].nil? ? puppetversion = '~>3.8.7' : puppetversion = ENV['PUPPET_VERSION'].to_s
gem 'puppet', puppetversion, :require => false, :groups => [:test]
gem 'safe_yaml', '~> 1.0.4'

group :test do
  gem 'puppetlabs_spec_helper', '~> 2.0.1',                         :require => false
  gem 'parallel_tests',                                             :require => false
  gem 'rspec-puppet', '~> 2.5',                                     :require => false
  gem 'rspec-puppet-facts',                                         :require => false
  gem 'rspec-puppet-utils',                                         :require => false
  gem 'puppet-lint-absolute_classname-check',                       :require => false
  gem 'puppet-lint-leading_zero-check',                             :require => false
  gem 'puppet-lint-trailing_comma-check',                           :require => false
  gem 'puppet-lint-version_comparison-check',                       :require => false
  gem 'puppet-lint-classes_and_types_beginning_with_digits-check',  :require => false
  gem 'puppet-lint-unquoted_string-check',                          :require => false
  gem 'puppet-lint-variable_contains_upcase',                       :require => false
  gem 'metadata-json-lint',                                         :require => false
  gem 'simplecov-console',                                          :require => false
  gem 'coveralls',                                                  :require => false
  gem 'rake',                                                       :require => false
  gem 'puppet-blacksmith',                                          :require => false
  gem 'librarian-puppet',                                           :require => false
  gem 'beaker-rspec',                                               :require => false
end


# vim:ft=ruby
