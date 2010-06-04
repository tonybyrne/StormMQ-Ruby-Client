#--
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.
#++

module StormMQ
  module Utils
    # def self.stormmq_credentials_string(user, password)
    #   "\0#{user}\0#{password}"
    # end
  end
end

class String
  def blank?
    self.gsub(/\s+/,'') == ""
  end
end

class NilClass
  def blank?
    true
  end
end