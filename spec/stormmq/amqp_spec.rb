#--
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.
#++

require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'stormmq/amqp'

describe StormMQ::AMQPClient do

  it "adds default StormMQ client options to an option hash" do
    options = {
      :company     => 'a_company',
      :system      => 'a_system',
      :environment => 'an_environment'
    }
    new_options = StormMQ::AMQPClient.add_stormmq_options(options)
    
    new_options[:host].should  == 'amqp.stormmq.com'
    new_options[:port].should  == 443
    new_options[:vhost].should == '/a_company/a_system/an_environment'
    new_options[:ssl].should be_true
  end

  it "constructs the virtual host string from the StormMQ specific options in the connect option hash" do
    options = {
      :company     => 'a_company',
      :system      => 'a_system',
      :environment => 'an_environment'
    }
    StormMQ::AMQPClient.vhost_from_options(options).should == '/a_company/a_system/an_environment'
  end
  
  it "returns an instance of the Bunny AMQP client" do
    StormMQ::AMQPClient.instance.should be_instance_of(Bunny::Client)
  end

  it "run block in scope of Bunny AMQP client instance" do
    block = Proc.new { }
    options = StormMQ::AMQPClient.add_stormmq_options({})
    Bunny.should_receive(:run).with(options, &block)
    StormMQ::AMQPClient.run({}, &block)
  end
  
end

