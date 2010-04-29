#--
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.
#++

require File.dirname(__FILE__) + '/../../lib/stormmq/secret_keys'

describe StormMQ::SecretKeys do

  describe "secret_keys_hash_from_json" do

    it "should retrieve the secret key for a user from the json format key file" do
      json = '{"tonybyrne":"my key"}'
      StormMQ::SecretKeys.secret_keys_hash_from_json(json).should == { 'tonybyrne' => 'my key' }
    end

    it "it should uri decode the key" do
      json = '{"tonybyrne":"-_"}'
      StormMQ::SecretKeys.secret_keys_hash_from_json(json).should == { 'tonybyrne' => '+/' }
    end

  end

end
