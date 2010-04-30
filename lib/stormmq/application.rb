#--
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.
#++

require 'commandline'
require 'commandline/optionparser'

module StormMQ
  class Application < CommandLine::Application_wo_AutoRun

    def initialize(*args)
      author    "Tony Byrne"
      copyright "2010, Tony Byrne & StormMQ. All rights reserved."
      super(*args)
    end

    def option_user
      option :names           => %w(--user -u),
             :opt_description => "a valid user name, i.e. the login you use at http://stormmq.com/",
             :arity           => [1,1],
             :opt_found       => get_args
    end

    def option_company
      option :names           => %w(--company -c),
             :opt_description => "your company identifier, usually the same as --user",
             :arity           => [1,1],
             :opt_found       => get_args,
             :opt_not_found   => CommandLine::OptionParser::OPT_NOT_FOUND_BUT_REQUIRED
    end

    def rest_client
      begin
        Rest.client(:user => opt.user)
      rescue Error::UserNotProvidedError
        raise "Could not determine the user - either provide it via the --user option or set it via $STORMMQ_USER"
      rescue Error::SecretKeyNotProvidedError
        raise "Could not find the secret key for user '#{opt.user} - please ensure it is present in the secret key file"
      end
    end

  end
end