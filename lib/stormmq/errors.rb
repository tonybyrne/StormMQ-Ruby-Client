#--
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.
#++

module StormMQ

  module Error

    class LoadSecretKeysError < StandardError
    end

    class SecretKeyNotFoundError < StandardError
    end

    class UserNotProvidedError < StandardError
    end

  end

end