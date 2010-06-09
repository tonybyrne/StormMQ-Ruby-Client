#--
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.
#++

require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'stormmq/utils'

describe StormMQ::Utils do

  describe NilClass, 'blank?' do
  
    it "should extend NilClass to add a 'blank?' method" do
      nil.blank?.should be_true
    end

  end
  
  describe String, 'blank?' do
  
    it "a string with non space characters is not blank" do
      'not blank'.blank?.should be_false
    end

    it "an empty string is blank" do
      ''.blank?.should be_true
    end

    it "a string containing only space is blank" do
      '    '.blank?.should be_true
    end

  end

end
