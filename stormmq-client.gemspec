#!/usr/bin/env gem build
# encoding: utf-8
#
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.

require "base64"

Gem::Specification.new do |s|
  s.name        = "stormmq-client"
  s.version     = "0.0.2"
  s.authors     = ["Tony Byrne"]
  s.homepage    = "http://github.com/tonybyrne/StormMQ-Ruby-Client"
  s.summary     = "A client library for StormMQ's Cloud Messaging service"
  s.description = "#{s.summary}. See http://www.stormmq.com/ for details of the service."
  s.cert_chain  = nil
  s.email       = Base64.decode64("c3Rvcm1tcUBieXJuZWhxLmNvbQ==\n")
  s.has_rdoc    = false

  # files
  s.files = Dir['lib/**/*.rb'] + Dir['bin/*'] + Dir['spec/**/*'] + Dir['[A-Z]*']

  puts s.files.to_yaml

  s.executables = Dir["bin/*"].map(&File.method(:basename))

  s.require_paths = ["lib"]

  # Ruby version
  # s.required_ruby_version = ::Gem::Requirement.new("~> 1.8.6")

  # dependencies
  s.add_dependency             "amqp",        ">= 0.6.7"
  s.add_dependency             "rest-client", ">= 1.4.2"
  s.add_dependency             "ruby-hmac",   ">= 0.4.0"
  s.add_dependency             "json",        ">= 1.4.2"
  s.add_dependency             "commandline", ">= 0.7.10"
  s.add_development_dependency "rspec",       ">= 1.3.0"
  s.add_development_dependency "rake",        ">= 0.8.7"
  s.add_development_dependency "rcov",        ">= 0.9.7.1"



end
