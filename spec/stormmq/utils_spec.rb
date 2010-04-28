require File.dirname(__FILE__) + '/../../lib/stormmq/utils'

describe StormMQ::Utils do

  describe "stormmq_credentials_string" do
    it "constructs a credentials string for the AMQP service from from a user and password" do
      StormMQ::Utils.stormmq_credentials_string('tonybyrne', 'my_password').should == "\0tonybyrne\0my_password"
    end
  end

  describe "canonicalise_url" do

    it "should handle the simplest case" do
      StormMQ::Utils.canonicalise_url('https://api.stormmq.com/', 'tonybyrne', 0).should == 'https://api.stormmq.com:443/?user=tonybyrne&version=0'
    end

    it "should handle a complex case" do
      url   = 'https://api.stormmq.com/api/2009-01-01/%3D%25?empty=&%20novalue&foo=%2Fvalue'
      c_url = 'https://api.stormmq.com:443/api/2009-01-01/%3D%25?%20novalue=&empty=&foo=%2Fvalue&user=raph&version=0'
      StormMQ::Utils.canonicalise_url(url, 'raph', 0).should == c_url
    end

  end

  describe "query_string_to_hash" do

    it "should convert a simple query string to a hash representation" do
      StormMQ::Utils.querystring_to_hash("param=value").should == { 'param' => ['value'] }
    end

    it "should uri decode the query string" do
      StormMQ::Utils.querystring_to_hash("%20param=value%20").should == { ' param' => ['value '] }
    end

  end

  describe "hash_to_query_string" do

    it "should convert a hash with a single key value pair to a query string" do
      StormMQ::Utils.hash_to_querystring({'param' => ['value']}).should == "param=value"
    end

    it "should uri encode components of query string" do
      StormMQ::Utils.hash_to_querystring(
        {
          'param with spaces' => ['value with spaces']
        }
      ).should == "param%20with%20spaces=value%20with%20spaces"
    end

    it "should convert a hash with a single key, but multiple values to a query string, and sort the components" do
      StormMQ::Utils.hash_to_querystring({'param' => ['Z','X','Y']}).should == "param=X&param=Y&param=Z"
    end

    it "should convert a hash with a multiple keys, and multiple values to a query string, and sort the components" do
      StormMQ::Utils.hash_to_querystring(
        {
          'paramZ' => ['Z','X','Y'],
          'paramX' => ['1','3','2'],
          'paramY' => ['c','a','b']
        }
      ).should == "paramX=1&paramX=2&paramX=3&paramY=a&paramY=b&paramY=c&paramZ=X&paramZ=Y&paramZ=Z"
    end

  end

  describe "secret_keys_hash_from_json" do

    it "should retrieve the secret key for a user from the json format key file" do
      json = '{"tonybyrne":"my key"}'
      StormMQ::Utils.secret_keys_hash_from_json(json).should == { 'tonybyrne' => 'my key' }
    end

    it "it should uri decode the key" do
      json = '{"tonybyrne":"-_"}'
      StormMQ::Utils.secret_keys_hash_from_json(json).should == { 'tonybyrne' => '+/' }
    end

  end

end
