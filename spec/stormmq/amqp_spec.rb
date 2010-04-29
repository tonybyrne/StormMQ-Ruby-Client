# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.

require File.dirname(__FILE__) + '/../../lib/stormmq/amqp'

describe StormMQ::AMQPClient do
  it "constructs the virtual host string from the StormMQ specific options in the connect option hash" do
    options = {
      :company     => 'a_company',
      :system      => 'a_system',
      :environment => 'an_environment'
    }
    StormMQ::AMQPClient.vhost_from_options(options).should == '/a_company/a_system/an_environment'
  end
end

