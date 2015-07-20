# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pxeger/version'

Gem::Specification.new do |spec|
  spec.name          = "pxeger"
  spec.version       = Pxeger::VERSION
  spec.authors       = ["Naoki Shimizu"]
  spec.email         = ["hcs0035@gmail.com"]

  spec.summary       = %q{Random string generator from regular expression}
  spec.description   = %q{Random String generator from regular expression}
  spec.homepage      = "https://github.com/deme0607/pxeger"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3.0"
end
