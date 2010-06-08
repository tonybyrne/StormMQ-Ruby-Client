#--
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.
#++

module StormMQ
  module Utils
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