#--
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.
#++

require 'commandline'

module StormMQ
  class Application < CommandLine::Application
    def initialize(*args)
      author    "Tony Byrne"
      copyright "2010, Tony Byrne & StormMQ. All rights reserved."
      super(*args)
    end
  end
end