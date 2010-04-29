#--
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.
#++

module StormMQ

  module Error

    class Base < StandardError
    end

    class LoadSecretKeysError < StormMQ::Error::Base
    end

    class SecretKeyNotFoundError < StormMQ::Error::Base
    end

    class UserNotProvidedError < StormMQ::Error::Base
    end

    class InvalidURLError < StormMQ::Error::Base
    end

  end

end