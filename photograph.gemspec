# -*- encoding: utf-8 -*-
require File.expand_path('../lib/photograph/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jean Hadrien Chabran"]
  gem.email         = ["jh@chabran.fr"]
  gem.description   = %q{Small library to take screenshots of web pages}
  gem.summary       = %q{Small library to take screenshots of web pages}
  gem.homepage      = "https://github.com/jhchabran/photograph"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "photograph"
  gem.require_paths = ["lib"]
  gem.version       = Photograph::VERSION

  gem.add_dependency 'poltergeist'
  gem.add_dependency 'mini_magick'

  gem.add_development_dependency 'rspec', '~> 2.14'
  gem.add_development_dependency 'rake'

  gem.post_install_message = 'DEPRECATION: Photograph::Artist#new :wait option had been renamed to :sleep. :wait will be ignored in the next version.'
end
