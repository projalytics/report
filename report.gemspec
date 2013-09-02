# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
  
require 'report/version'

Gem::Specification.new do |s|
    s.name          = 'report'
    s.version       = Report::Version
    s.platform      = Gem::Platform::RUBY
    s.authors       = ['Louis Salin']
    s.email         = ['louis.phil@gmail.com']
    s.homepage      = 'http://github.com/projalytics/report'
    s.license       = 'MIT'
    s.summary       = 'reporting side of CQRS app'
    s.description   = 'listens to domain events and keeps DB in sync'

    s.add_development_dependency 'rspec'
    s.add_development_dependency 'sqlite3'
    s.add_runtime_dependency 'bunny'
    s.add_runtime_dependency 'sequel'

    s.files         = Dir.glob("lib/**/*") + %w(LICENSE README.md CHANGELOG.md)
    s.require_path  = 'lib'
    s.executables << 'report'
end
