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

