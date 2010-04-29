#--
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.
#++

require "rubygems"
require "json"
require "rest_client"

module StormMQ

  API_PATH       = "/api/2009-01-01"
  COMPANIES_PATH = '/companies/'

  class Rest

    attr_accessor :user
    attr_accessor :url_options

    def initialize(options={})
      @user        = options.delete(:user)       || ENV['STORMMQ_USER'] || (raise StormMQ::Error::UserNotProvidedError, "could not determine the user.")
      @api         = options.delete(:api)        || API_PATH
      @key         = options.delete(:secret_key) || StormMQ::SecretKeys.instance.key_for(@user)
      @url_options = options
    end

    def companies
      get(build_signed_resource_url(COMPANIES_PATH))
    end

    private

    def get(signed_url)
      JSON.parse(RestClient.get(signed_url.to_s, {:accept => '*/*'}).to_s)
    end

    def build_signed_resource_url(path='/')
      StormMQ::URL.new(
        {
          :host   => 'api.stormmq.com',
          :scheme => 'https',
          :path   => @api + path
        }.merge(@url_options)
      ).canonicalise(@user).sign(@key)
    end

  end

end