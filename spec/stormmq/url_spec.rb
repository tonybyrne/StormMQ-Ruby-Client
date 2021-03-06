#--
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.
#++

require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'stormmq/url'

describe StormMQ::URL do

  describe "to_s" do

    it "should return the url as a string" do
      StormMQ::URL.new('https://api.stormmq.com/').to_s.should == 'https://api.stormmq.com/'
    end

  end

  describe "canonicalise" do

    it "adds explicit port for HTTP" do
      StormMQ::URL.new('http://api.stormmq.com/').canonicalise('test').to_s.should == 'http://api.stormmq.com:80/?user=test&version=0'
    end

    it "adds explicit port for HTTPS" do
      StormMQ::URL.new('https://api.stormmq.com/').canonicalise('test').to_s.should == 'https://api.stormmq.com:443/?user=test&version=0'
    end

    it "sorts query string params by param name" do
      StormMQ::URL.new('https://api.stormmq.com/?z=3&x=1&y=2').canonicalise('test').to_s.should == 'https://api.stormmq.com:443/?user=test&version=0&x=1&y=2&z=3'
    end

    it "sorts query string params with multiple values by value" do
      StormMQ::URL.new('https://api.stormmq.com/?z=3&x=1&y=2&z=1').canonicalise('test').to_s.should == 'https://api.stormmq.com:443/?user=test&version=0&x=1&y=2&z=1&z=3'
    end

    it "should canonicalise complex example from http://stormmq.com/rest-apis/for-security-reasons (without user and version params)" do
      url = 'https://api.stormmq.com/api/2009-01-01/%3D%25?empty=&%20novalue&foo=%2Fvalue'
      expected = 'https://api.stormmq.com:443/api/2009-01-01/%3D%25?%20novalue=&empty=&foo=%2Fvalue&user=raph&version=0'
      StormMQ::URL.new(url).canonicalise('raph').to_s.should == expected
    end

  end

  describe "add_query_params" do

    before(:each) do
      @url = StormMQ::URL.new('http://api.stormmq.com/')
    end

    it "should add params to the querystring and canonicalise the querystring" do
      @url.add_query_params('z' => 3, 'x' => 1, 'y' => 2).to_s.should == 'http://api.stormmq.com/?x=1&y=2&z=3'
    end

    it "should add params as symbols to the querystring and canonicalise the querystring" do
      @url.add_query_params(:z => 3, :x => 1, :y => 2).to_s.should == 'http://api.stormmq.com/?x=1&y=2&z=3'
    end

    it "should add params with multiple values to the querystring and canonicalise the querystring" do
      @url.add_query_params(:z => [3,1,2]).to_s.should == 'http://api.stormmq.com/?z=1&z=2&z=3'
    end

    it "should URI escape params and values added to a URL" do
      @url.add_query_params(' test ' => 'a+value').to_s.should == 'http://api.stormmq.com/?%20test%20=a%2Bvalue'
    end

  end

  describe "add_user_and_version_query_params" do

    before(:each) do
      @url = StormMQ::URL.new('http://api.stormmq.com/')
    end

    it "should add the user and version querystring params to a URL" do
      @url.add_user_and_version_query_params('tonybyrne',1).to_s.should == 'http://api.stormmq.com/?user=tonybyrne&version=1'
    end

    it "version should default to '0'" do
      @url.add_user_and_version_query_params('tonybyrne').to_s.should == 'http://api.stormmq.com/?user=tonybyrne&version=0'
    end

  end

  describe "query_string_to_hash" do

    it "should convert a simple query string to a hash representation" do
      StormMQ::URL.querystring_to_hash("param=value").should == { 'param' => ['value'] }
    end

    it "should uri decode the query string" do
      StormMQ::URL.querystring_to_hash("%20param=value%20").should == { ' param' => ['value '] }
    end

  end

  describe "hash_to_canonical_querystring" do

    it "should convert a hash with a single key value pair to a query string" do
      StormMQ::URL.hash_to_canonical_querystring({'param' => ['value']}).should == "param=value"
    end

    it "should uri encode components of query string" do
      StormMQ::URL.hash_to_canonical_querystring(
        {
          'param with spaces' => ['value with spaces']
        }
      ).should == "param%20with%20spaces=value%20with%20spaces"
    end

    it "should convert a hash with a single key, but multiple values to a query string, and sort the components" do
      StormMQ::URL.hash_to_canonical_querystring({'param' => ['Z','X','Y']}).should == "param=X&param=Y&param=Z"
    end

    it "should convert a hash with a multiple keys, and multiple values to a query string, and sort the components" do
      StormMQ::URL.hash_to_canonical_querystring(
        {
          'paramZ' => ['Z','X','Y'],
          'paramX' => ['1','3','2'],
          'paramY' => ['c','a','b']
        }
      ).should == "paramX=1&paramX=2&paramX=3&paramY=a&paramY=b&paramY=c&paramZ=X&paramZ=Y&paramZ=Z"
    end

  end

  describe "valid?" do
    
    it "a valid URL" do
      StormMQ::URL.new("http://www.byrnehq.com").valid?.should be_true
    end

    it "an invalid URL" do
      lambda { StormMQ::URL.new("random://www") }.should raise_error(StormMQ::Error::InvalidURLError)
    end
    
    it "an invalid URI as detected by URI.parse" do
      URI.should_receive(:parse).and_raise URI::InvalidURIError
      lambda { StormMQ::URL.new({:host => 'www.byrnehq.com'}) }.should raise_error(StormMQ::Error::InvalidURLError)
    end
    
  end

  describe "to_h" do
    
    before(:each) do
      @hash = StormMQ::URL.new('http://www.stormmq.com:81/path?query=1').to_h
    end
    
    it "should extract the scheme" do
      @hash[:scheme].should == 'http'
    end

    it "should extract the host" do
      @hash[:host].should == 'www.stormmq.com'
    end

    it "should extract the port" do
      @hash[:port].should == '81'
    end

    it "should extract the path" do
      @hash[:path].should == '/path'
    end

    it "should extract the query" do
      @hash[:query].should == 'query=1'
    end

    it "should not contain a fragment" do
      @hash[:fragment].should be_nil
    end

    it "should not contain an opaque" do
      @hash[:opaque].should be_nil
    end

    it "should not contain a registry" do
      @hash[:registry].should be_nil
    end
    
  end

  describe "canonicalise and sign" do
    
    it "should canonicalise and sign a URL (in one step)" do
      base64key = "d60bfe079c88f2c78310131d9bb419214ec3badb0bdfccb20a1c568f380426c5"
      key = Base64::decode64(base64key)
      StormMQ::URL.new('http://api.stormmq.com/').canonicalise_and_sign('test', base64key).to_s.should  ==
        'http://api.stormmq.com:80/?signature=qQC5BNDK5rMOxLC0G2hkOoW5Z7P-c4aO2pok5r0V0Ac%3D&user=test&version=0'      
    end
    
  end

end
