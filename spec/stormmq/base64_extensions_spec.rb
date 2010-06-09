#--
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.
#++

require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'base64'
require 'stormmq/base64_extensions'

describe Base64 do
  
  before(:each) do
    @unsafe_encoded = "jv7N7mnDnl4FWgayyxzN695zYJ4SC/OTnXel9SPIP/2XV6d7+3vTyV4v0zQWAfvNwZm/bB/h6P+X+FUUdcvJig=="
    @safe_encoded   = "jv7N7mnDnl4FWgayyxzN695zYJ4SC_OTnXel9SPIP_2XV6d7-3vTyV4v0zQWAfvNwZm_bB_h6P-X-FUUdcvJig=="
  end
  
  it "implements a URL safe base64 decode" do
    Base64.encode64(Base64.urlsafe_decode64(@safe_encoded)).gsub(/\n/,'').should == @unsafe_encoded
  end

  it "implements a URL safe base64 encode" do
    Base64.urlsafe_encode64(Base64.decode64(@unsafe_encoded)).gsub(/\n/,'').should == @safe_encoded
  end

end
