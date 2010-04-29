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
  class Application < CommandLine::Application

    def initialize(*args)
      author    "Tony Byrne"
      copyright "2010, Tony Byrne & StormMQ. All rights reserved."
      super(*args)
    end

    def option_user
      option :names           => %w(--user -u),
             :opt_description => "a valid user name, i.e. the login you use at http://stormmq.com/",
             :arity           => [1,1],
             :opt_found       => get_args,
             :opt_not_found   => ENV['STORMMQ_USER']
    end

    def option_company
      option :names           => %w(--company -c),
             :opt_description => "your company identifier, usually the same as --user",
             :arity           => [1,1],
             :opt_found       => get_args,
             :opt_not_found   => CommandLine::OptionParser::OPT_NOT_FOUND_BUT_REQUIRED
    end

    def rest_client
      StormMQ::Rest.new(opt.user, self.secret_key)
    end

    def secret_key
      raise_error_if_user_not_provided
      StormMQ::SecretKeys.key_for(opt.user)
    end

    def raise_error_if_user_not_provided
      if opt.user.blank?
        raise StormMQ::Error::UserNotProvidedError, "User could not be determined. Either set $STORMMQ_USER to a valid user name, or provide one with the --user option"
      end
    end

  end
end