#--
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.
#++

require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'base64'
require 'stormmq/secret_keys'
require 'stormmq/base64_extensions'
require 'stormmq/errors'

describe StormMQ::SecretKeys do

  describe "secret_keys_hash_from_json" do

    it "should load the secret key for a user from the json format string" do
      url_safe_base64_key = "BNuWk1agaAUPTZ15sx44kHvNkTnJXsevqTjIo1M1iwFOeNaUqr3qP-_5Dnk=="
      json = %Q|{"tonybyrne":"#{url_safe_base64_key}"}|
      StormMQ::SecretKeys.secret_keys_hash_from_json(json).should == { 'tonybyrne' => Base64.urlsafe_decode64(url_safe_base64_key) }
    end

  end

  describe "loading of keys from keyfile" do
    
    it "should throw an error when keyfile does not exist" do
      keystore = StormMQ::SecretKeys.instance
      lambda { keystore.load_secret_keys('/non-existing-path') }.should raise_error(StormMQ::Error::LoadSecretKeysError)
    end
    
    it "should load keys from a file" do
      keystore = StormMQ::SecretKeys.instance
      lambda { keystore.load_secret_keys(File.join('spec')) }.should_not raise_error(StormMQ::Error::LoadSecretKeysError)
    end
    
    it "should handle an error while reading the keyfile" do
      IO.should_receive(:read).and_raise "bang! The universe has ended."
      keystore = StormMQ::SecretKeys.instance
      lambda { keystore.load_secret_keys(File.join('spec')) }.should raise_error(StormMQ::Error::LoadSecretKeysError)
    end
    
  end

  describe "key and user retrieval" do
    
    before(:each) do
      @keystore = StormMQ::SecretKeys.instance
      @keystore.forget_keys
      @keystore.load_secret_keys(File.join('spec'))
    end
    
    it "should return a list of users found in the key file" do
      @keystore.users.should == ['test']
      StormMQ::SecretKeys.key_for('test').should_not be_nil
    end

    it "should retrieve the key for a named user" do
      @keystore.key_for('test').should_not be_nil
    end
    
    it "should retrieve the key for a named user when using the class method" do
      StormMQ::SecretKeys.key_for('test').should_not be_nil
    end
    
    it "should raise an error when a key for a named user is not present in the keyfile" do
      lambda { @keystore.key_for('wibble') }.should raise_error(StormMQ::Error::SecretKeyNotFoundError)
    end
    
  end

end
