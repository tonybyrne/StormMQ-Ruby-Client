#--
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.
#++

module Base64

  def urlsafe_decode64(str)
    decode64(str.tr("-_", "+/"))
  end

  def urlsafe_encode64(bin)
    encode64(bin).tr("+/", "-_")
  end

end