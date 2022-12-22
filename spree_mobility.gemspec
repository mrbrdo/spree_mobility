# coding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_mobility/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_mobility'
  s.version     = SpreeMobility.version
  s.summary     = 'Better model translation for Spree'
  s.description = 'Provides model translation, localization, globalization features for Spreecommerce. Based on the Mobility gem, successor of Globalize.'

  s.author      = 'Jan Berdajs'
  s.email       = 'mrbrdo@mrbrdo.net'
  s.homepage    = 'https://github.com/mrbrdo'
  s.license     = 'BSD-3-Clause'

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- spec/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  spree_version =  '>= 4.5.0', '< 5.0'
  s.add_runtime_dependency 'spree_core', spree_version
  s.add_runtime_dependency 'spree_api_v1', '>= 4.5.0'
  s.add_runtime_dependency 'spree_extension'
  s.add_runtime_dependency 'friendly_id-mobility'
  s.add_runtime_dependency 'mobility'
  s.add_runtime_dependency 'spree_i18n'
  s.add_runtime_dependency 'i18n_data'
  s.add_runtime_dependency 'rails-i18n'
  s.add_runtime_dependency 'kaminari-i18n'
  s.add_runtime_dependency 'deface', '~> 1.0'

  s.add_development_dependency 'acts_as_paranoid'
  s.add_development_dependency 'spree_dev_tools'
end
