# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'preciousss/version'

Gem::Specification.new do |s|
  s.name        = 'preciousss'
  s.version     = Preciousss::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['sodercober']
  s.email       = ['sodercober@gmail.com']
  s.homepage    = 'https://github.com/sodercober/preciousss'
  s.summary     = %q{Several helpers for Ruby on Rails 3}
  s.description = %q{Several helpers for Ruby on Rails 3}

  s.rubyforge_project = 'preciousss'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
