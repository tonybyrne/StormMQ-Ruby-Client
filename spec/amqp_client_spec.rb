require 'stormmq-amqp'

describe StormMQ::Utils do
  it "constructs a credentials string from from a user and password" do
    StormMQ::Utils.stormmq_credentials_string('tonybyrne', 'my_password').should == "\0tonybyrne\0my_password"
  end
end

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