#--
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.
#++

require 'singleton'
require 'json'
require 'base64'
require 'stormmq/base64_extensions'
require 'stormmq/errors'
require 'stormmq/utils'

module StormMQ

  SECRET_KEYS_SEARCH_PATH = [
    File.join(ENV['HOME'], '.stormmq'),
    File.join('/', 'etc', 'stormmq')
  ]

  SECRET_KEYS_FILENAME    = 'secret-keys.json'

  class SecretKeys
    include Singleton

    # Returns the secret key for the given user name from the secret keys file.
    def key_for(user)
      raise Error::UserNotProvidedError, "user cannot be blank." if user.blank?
      keys[user] || (raise Error::SecretKeyNotFoundError, "a secret key for user '#{user}' could not be found in the secret key file.", caller)
    end

    # Returns an <tt>Array</tt> of user names of users who have keys in the secret keys file.
    def users
      keys.keys
    end

    # Load the keys from the secret keys file <tt>keyfile</tt>.  Walks the locations specified in
    # <tt>search_path</tt> in order of preference.
    def load_secret_keys(search_path=SECRET_KEYS_SEARCH_PATH, keyfile=SECRET_KEYS_FILENAME)
      full_paths = search_path.map{|p| File.expand_path(File.join(p,keyfile))}
      full_paths.each do |full_path|
        begin
          return @secret_keys_cache = SecretKeys.secret_keys_hash_from_json(IO.read(full_path))
        rescue
          # A dummy statement so that this branch is picked up by rcov
          dummy = true
        end
      end
      raise Error::LoadSecretKeysError,
          "Could not read the secret keys file from any of [#{full_paths.join ', '}]. Please ensure that a valid keyfile exists in one of these locations and that it is readable.",
          caller
    end

    def forget_keys
      @secret_keys_cache = nil
    end

    private

    # Return a hash of keys stored in the secret keys file.
    def keys
      @secret_keys_cache ||= load_secret_keys
    end


    def self.key_for(*args)
      self.instance.key_for(*args)
    end

    # Create a hash of the keys contained in json fragment.
    def self.secret_keys_hash_from_json(json_string)
      secret_keys_hash = JSON.parse(json_string)
      secret_keys_hash.inject({}) { |h,(k,v)| h[k] = Base64.urlsafe_decode64(v); h }
    end

  end

end