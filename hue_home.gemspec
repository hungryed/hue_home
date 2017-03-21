# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hue_home/version'

Gem::Specification.new do |spec|
  spec.name          = "hue_home"
  spec.version       = HueHome::VERSION
  spec.authors       = ["Joe Sutton"]
  spec.email         = ["hungryed6@gmail.com"]

  spec.summary       = %q{Summary of Hue Home}
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 0.11"
  spec.add_dependency 'thor', "~> 0.19"
  spec.add_dependency 'highline', "~> 1.7"

  spec.add_development_dependency "bundler", "~> 1.14.6"
  spec.add_development_dependency "rb-readline", "~> 0.5.4"
  spec.add_development_dependency "pry", "~> 0.10.4"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3"
end
