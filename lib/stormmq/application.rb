#--
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.
#++

require 'stormmq/errors'
require 'stormmq/rest'
require 'commandline'
require 'commandline/optionparser'

module StormMQ
  class Application < CommandLine::Application_wo_AutoRun

    def initialize(*args)
      author    "Tony Byrne"
      copyright "2010, Tony Byrne & StormMQ. All rights reserved."
      super(*args)
    end

    def rest_client(user)
      begin
        Rest.new(:user => user)
      rescue Error::SecretKeyNotProvidedError
        raise "Could not find the secret key for user '#{user}' - please ensure it is present in the secret key file"
      end
    end

    def self_test
      'Self test ouput goes here'
    end

  end
end