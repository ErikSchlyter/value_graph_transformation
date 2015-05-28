# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'value_graph_transformation/version'

Gem::Specification.new do |spec|
  spec.name          = "value_graph_transformation"
  spec.version       = ValueGraphTransformation::VERSION
  spec.authors       = ["Erik Schlyter"]
  spec.email         = ["erik@erisc.se"]

  spec.summary       = %q{A simple framework for DAG manipulation.}
  spec.description   = %q{A simple framework for DAG manipulation.}
  spec.homepage      = "https://github.com/ErikSchlyter/value_graph_transformation"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 1.9.3'

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec-illustrate", "~> 0.2.2"
  spec.add_development_dependency "yard", "~>  0.8.7.6"
  spec.add_development_dependency "redcarpet", "~>  3.2.2"
  spec.add_development_dependency "method_source", "~> 0.8.2"
end
