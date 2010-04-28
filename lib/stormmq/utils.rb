require 'uri'
require 'cgi'
require 'json'
require 'hmac'
require 'hmac-sha2'
require 'base64'

module StormMQ
  module Utils

    SCHEMES_DEFAULT_PORTS = {
      'http'  => 80,
      'https' => 443
    }

    SECRET_KEYS_SEARCH_PATH = ['~/.stormmq','/etc']
    SECRET_KEYS_FILENAME    = 'secret-keys.json'

    def self.stormmq_credentials_string(user, password)
      "\0#{user}\0#{password}"
    end

    def self.querystring_to_hash(querystring)
      return {} if querystring.nil?
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
      return '' if string.nil?
      URI.escape(string, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end

    def self.sign_url(method, url, base64key)
      hmac = HMAC::SHA256.new(Base64.decode64(base64key))
      hmac.update("#{method}#{url}")
      signature = Base64.encode64(hmac.digest).tr("+/","-_").chomp
      url + '&signature=' + URI.encode(signature)
    end

    def self.canonicalise_url(url, user, version=0)
      components = split_url(url)
      canonical  = { :port => default_port_for_scheme(components[:scheme]) }.merge(components)
      canonical_query_hash = querystring_to_hash(components[:query])
      canonical_query_hash.merge!( :user => [user], :version => [version.to_s])
      canonical_query_string = hash_to_querystring(canonical_query_hash)

      URI::Generic.build(
        :scheme  => canonical[:scheme],
        :host    => canonical[:host],
        :port    => canonical[:port],
        :path    => canonical[:path],
        :query   => canonical_query_string
      ).to_s
    end

    # split a URL into its components and return them in a hash keyed by component name. Only components
    # that are present in the URL are present in the returned hash.
    def self.split_url(url)
      components = URI.split(url)
      {
        :scheme => components[0],
        :host   => components[2],
        :port   => components[3],
        :path   => components[5],
        :query  => components[7]
      }.reject {|k,v| v.nil?}
    end

    def self.default_port_for_scheme(scheme)
      SCHEMES_DEFAULT_PORTS[scheme.downcase]
    end

    def self.secret_keys_hash_from_json(json_string)
      hash = JSON.parse(json_string)
      hash.values.each {|v| v.tr!("-_","+/")}
      hash
    end

    def self.load_secret_keys(search_path=SECRET_KEYS_SEARCH_PATH, keyfile=SECRET_KEYS_FILENAME)
      full_paths = search_path.map{|p| File.expand_path("#{p}/#{keyfile}")}
      full_paths.each do |full_path|
        begin
          return secret_keys_hash_from_json(IO.read(full_path))
        rescue
        end
      end
      raise StormMQ::Error::LoadSecretKeysError,
          "Could not read the secret keys file from any of [#{full_paths.join ', '}]. Please ensure that a valid keyfile exists in one of these locations and that it is readable.",
          caller
    end

  end
end