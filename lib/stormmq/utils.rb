require 'uri'
require 'cgi'

module StormMQ
  module Utils

    SCHEMES_DEFAULT_PORTS = {
      'http'  => 80,
      'https' => 443
    }

    def self.stormmq_credentials_string(user, password)
      "\0#{user}\0#{password}"
    end

    def self.querystring_to_hash(querystring)
      CGI.parse(querystring)
    end

    def self.hash_to_querystring(options)
      components = []
      options.each do |key,values|
        values.each {|v| components << "#{uri_escape(key.to_s)}=#{uri_escape(v)}" }
      end
      components.sort.join('&')
    end

    def self.uri_escape(string)
      URI.escape(string, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end

    def self.canonicalise_url(url)

      components = split_url(url)

      canonical = {
        :port    => default_port_for_scheme(components[:scheme])
      }.merge(components)

      URI::Generic.build(
        :scheme  => canonical[:scheme],
        :host    => canonical[:host],
        :port    => canonical[:port]
      ).to_s
    end

    # split a URL into its components and return them in a hash keyed by component name. Only components
    # that are present in the URL are present in the returned hash.
    def self.split_url(url)
      components = URI.split(url)
      {
        :scheme => components[0],
        :host   => components[2],
        :port   => components[3]
      }.reject {|k,v| v.nil?}
    end

    def self.default_port_for_scheme(scheme)
      SCHEMES_DEFAULT_PORTS[scheme.downcase]
    end

  end
end