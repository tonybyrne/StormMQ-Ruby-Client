#!/usr/bin/env gem build
# encoding: utf-8

require "base64"

Gem::Specification.new do |s|
  s.name = "stormmq-client"
  s.version = "0.0.1"
  s.authors = ["Tony Byrne"]
  s.homepage = "http://www.byrnehq.com/"
  s.summary = "A client for StormMQ's Cloud Messaging service"
  s.description = "#{s.summary}. Basic for now."
  s.cert_chain = nil
  s.email = Base64.decode64("c3Rvcm1tcUBieXJuZWhxLmNvbQ==\n")
  s.has_rdoc = false

  # files
  s.files = Dir['lib/**/*.rb'] + Dir['bin/*']
  s.files << Dir['[A-Z]*'] + Dir['test/**/*']
  s.files.reject! { |fn| fn.include? "CVS" }

  s.executables = Dir["bin/*"].map(&File.method(:basename))

  # s.default_executable = "stormmq-amqp-echo-test"
  s.require_paths = ["lib"]

  # Ruby version
  s.required_ruby_version = ::Gem::Requirement.new("~> 1.8")

  # dependencies
  # RubyGems has runtime dependencies (add_dependency) and
  # development dependencies (add_development_dependency)
  s.add_dependency "amqp", ">= 0.6.7"

end
