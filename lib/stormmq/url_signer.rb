#--
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.
#++

module StormMQ

  class URLSigner

    def self.sign(url, options={})
      secret_key   = StormMQ::SecretKeys.instance.key_for(options[:user])
      StormMQ::URL.new(url).canonicalise(options[:user]).sign(secret_key, options[:method])
    end

  end

end