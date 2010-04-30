#--
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.
#++

require 'base64'
require File.dirname(__FILE__) + '/../../lib/stormmq/secret_keys'
require File.dirname(__FILE__) + '/../../lib/stormmq/base64_extensions'

describe StormMQ::SecretKeys do

  describe "secret_keys_hash_from_json" do

    it "should load the secret key for a user from the json format string" do
      url_safe_base64_key = "BNuWk1agaAUPTZ15sx44kHvNkTnJXsevqTjIo1M1iwFOeNaUqr3qP-_5Dnk=="
      json = %Q|{"tonybyrne":"#{url_safe_base64_key}"}|
      StormMQ::SecretKeys.secret_keys_hash_from_json(json).should == { 'tonybyrne' => Base64.urlsafe_decode64(url_safe_base64_key) }
    end

  end

end
