# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'colonel/version'

Gem::Specification.new do |gem|
  gem.name          = "colonel"
  gem.version       = Colonel::VERSION
  gem.authors       = ["santaux"]
  gem.email         = ["santaux@gmail.com"]
  gem.description   = %q{Gem for managing cron jobs with web GUI}
  gem.summary       = %q{Gem for managing cron jobs with web GUI}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "vegas", "~> 0.1.2"
  gem.add_dependency "sinatra", ">= 0.9.2"
  gem.add_dependency "haml"
  gem.add_dependency "coffee-script"
end
