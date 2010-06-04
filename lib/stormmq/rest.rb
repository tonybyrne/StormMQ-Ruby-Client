#--
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.
#++

require 'stormmq/url'
require 'stormmq/errors'
require 'stormmq/secret_keys'
require 'json'
require 'rest_client'

module StormMQ

  API_HOST       = ENV['STORMMQ_HOST']        || "api.stormmq.com"
  API            = ENV['STORMMQ_API']         || "api"
  API_VERSION    = ENV['STORMMQ_API_VERSION'] || "2009-01-01"

  COMPANIES_PATH = '/companies/'
  CLUSTERS_PATH  = '/clusters'
  APIS_PATH      = '/'

  # The Rest class implements the client for StormMQ's RESTful API.  The API allows clients to access
  # company, system and environment information.

  class Rest

    def initialize(options={})
      unless @user = options.delete(:user)
        raise Error::UserNotProvidedError,
          "could not determine the user name - either provide it via the :user param",
            caller
      end

      unless @secret_key = options.delete(:secret_key) || self.class.secret_key_from_key_store(@user)
        raise Error::SecretKeyNotProvidedError, "could not determine the secret key for user '#{@user}' - either provide it via the :secret_key param or ensure it is available in the secret key file",
          caller
      end

      @host        = options.delete(:host)    || API_HOST
      @api         = options.delete(:api)     || API
      @version     = options.delete(:version) || API_VERSION

      @url_options = options
    end

    # Returns an Array of company indentifiers associated with the user.
    def companies
      signed_get(COMPANIES_PATH)
    end

    # Takes a String containing a valid company identifier and returns a
    # Hash representation of the detailed information stored on the StormMQ
    # system about the company.
    def describe_company(company)
      signed_get(COMPANIES_PATH, escape(company))
    end

    def systems(company)
      signed_get(COMPANIES_PATH, escape(company), '/')
    end

    def describe_system(company, system)
      signed_get(COMPANIES_PATH, escape(company), escape(system))
    end

    def clusters(company)
      signed_get(CLUSTERS_PATH, escape(company))
    end

    def apis
      signed_get(APIS_PATH)
    end

    private

    def signed_get(*path_args)
      get(build_signed_resource_url(make_normalised_path(*path_args)))
    end

    def escape(string) # :nodoc:
      StormMQ::URL.escape(string)
    end

    def get(signed_url) # :nodoc:
      JSON.parse(RestClient.get(signed_url.to_s, {:accept => '*/*'}).to_s)
    end

    def build_signed_resource_url(resource_path='/', method='GET') # :nodoc:
      StormMQ::URL.new(
        {
          :host   => @host,
          :scheme => 'https',
          :path   => make_normalised_path(@api, @version, resource_path)
        }.merge(@url_options)
      ).canonicalise_and_sign(@user, @secret_key, method)
    end

    def make_normalised_path(*args) # :nodoc:
      ('/' + args.join('/')).gsub(/\/+/,'/')
    end

    def self.secret_key_from_key_store(user) # :nodoc:
      begin
        SecretKeys.key_for(user)
      rescue
      end
    end

  end

end