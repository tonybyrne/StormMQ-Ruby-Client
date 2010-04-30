#--
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.
#++

require "json"
require "rest_client"

module StormMQ

  API_HOST            = ENV['STORMMQ_HOST']        || "api.stormmq.com"
  API                 = ENV['STORMMQ_API']         || "api"
  API_VERSION         = ENV['STORMMQ_API_VERSION'] || "2009-01-01"

  LIST_COMPANIES_PATH = '/companies/'
  LIST_CLUSTERS_PATH  = '/clusters'
  LIST_APIS_PATH      = '/'

  class Rest

    class << self
      attr_accessor :paranoid
    end

    attr_accessor :user
    attr_accessor :url_options

    private_class_method :new

    def self.client(options={})
      unless user = (user_from_options(options) || user_from_environment)
        raise Error::UserNotProvidedError,
          "could not determine the user name - either provide it via the :user param or, if not paranoid, set it via the STORMMQ_USER environment variable",
            caller
      end

      unless secret_key = (secret_key_from_options(options) || secret_key_from_key_store(user))
        raise Error::SecretKeyNotProvidedError, "could not determine the secret key for user '#{user}' - either provide it via the :secret_key param or ensure it is available in the secret key file",
          caller
      end

      new(user, secret_key, API_HOST, API, API_VERSION, options)

    end

    def initialize(user, secret_key, host, api, version, options={})
      @user        = user
      @secret_key  = secret_key
      @host        = host
      @api         = api
      @version     = version
      @url_options = options
    end

    def companies
      get(build_signed_resource_url(LIST_COMPANIES_PATH))
    end

    def clusters(company)
      get(build_signed_resource_url(LIST_CLUSTERS_PATH + '/' + StormMQ::URL.escape(company)))
    end

    def apis
      get(build_signed_resource_url(LIST_APIS_PATH))
    end

    private

    def get(signed_url)
      JSON.parse(RestClient.get(signed_url.to_s, {:accept => '*/*'}).to_s)
    end

    def build_signed_resource_url(resource_path='/', method='GET')
      StormMQ::URL.new(
        {
          :host   => @host,
          :scheme => 'https',
          :path   => make_normalised_path(@api, @version, resource_path)
        }.merge(@url_options)
      ).canonicalise_and_sign(@user, @secret_key, method)
    end

    def make_normalised_path(*args)
      ('/' + args.join('/')).gsub(/\/+/,'/')
    end

    def self.user_from_options(options={})
      options.delete(:user)
    end

    def self.user_from_environment
      self.paranoid ? nil : ENV['STORMMQ_USER']
    end

    def self.secret_key_from_options(options={})
      options.delete(:secret_key)
    end

    def self.secret_key_from_key_store(user)
      begin
        SecretKeys.key_for(user)
      rescue
      end
    end

  end

end