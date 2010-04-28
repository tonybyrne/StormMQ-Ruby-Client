require File.dirname(__FILE__) + '/../../lib/stormmq/utils'

describe StormMQ::Utils do

  describe "stormmq_credentials_string" do
    it "constructs a credentials string for the AMQP service from from a user and password" do
      StormMQ::Utils.stormmq_credentials_string('tonybyrne', 'my_password').should == "\0tonybyrne\0my_password"
    end
  end

end
