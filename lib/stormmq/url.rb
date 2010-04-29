# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.

require 'rubygems'
require 'uri'
require 'cgi'
require 'hmac'
require 'hmac-sha2'
require 'base64'

module StormMQ

  SCHEMES_DEFAULT_PORTS = {
    'http'  => 80,
    'https' => 443
  }

  class URL

    def initialize(url)
      if url.is_a?(Hash)
        @url = URI::Generic.build(url).to_s
      else
        @url = url
      end
    end

    def to_s
      @url
    end

    def add_query_params(params_hash)
      components = to_h
      query_hash = StormMQ::URL.querystring_to_hash(components[:query])
      components[:query] = StormMQ::URL.hash_to_canonical_querystring(
        query_hash.merge(params_hash)
      )
      self.class.new(components)
    end

    def add_user_and_version_query_params(user, version=0)
        add_query_params(:user => [user], :version => [version.to_s])
    end

    def canonicalise(user, version=0)
      components         = self.add_user_and_version_query_params(user, version).to_h
      components[:query] = StormMQ::URL.canonicalise_query_string(components[:query]) unless components[:query].nil?
      canonical          = { :port => StormMQ::URL.default_port_for_scheme(components[:scheme]) }.merge(components)
      self.class.new(canonical)
    end

    def sign(base64key, method='GET')
      self.add_query_params('signature' => signature(base64key, method))
    end

    def signature(base64key, method='GET')
      hmac = HMAC::SHA256.new(Base64.decode64(base64key))
      hmac.update("#{method.upcase}#{self.to_s}")
      Base64.encode64(hmac.digest).tr("+/","-_").chomp
    end

    def to_h
      components = URI.split(@url)
      {
        :scheme   => components[0],
        :userinfo => components[1],
        :host     => components[2],
        :port     => components[3],
        :registry => components[4],
        :path     => components[5],
        :opaque   => components[6],
        :query    => components[7],
        :fragment => components[8]
      }.reject {|k,v| v.nil?}
    end

    def self.uri_escape(string)
      return '' if string.nil?
      URI.escape(string, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end

    def self.default_port_for_scheme(scheme)
      SCHEMES_DEFAULT_PORTS[scheme.downcase]
    end

    def self.querystring_to_hash(querystring)
      return {} if querystring.nil?
      CGI.parse(querystring)
    end

    def self.hash_to_canonical_querystring(options)
      components = []
      options.each do |key,values|
        [values].flatten.each {|v| components << "#{StormMQ::URL.uri_escape(key.to_s)}=#{StormMQ::URL.uri_escape(v.to_s)}" }
      end
      components.sort.join('&')
    end

    def self.canonicalise_query_string(querystring)
      query_hash = StormMQ::URL.querystring_to_hash(querystring)
      StormMQ::URL.hash_to_canonical_querystring(query_hash)
    end

  end

end