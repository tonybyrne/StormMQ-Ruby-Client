# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.

require 'rubygems'
require 'singleton'
require 'json'
require 'stormmq/errors'

module StormMQ

  SECRET_KEYS_SEARCH_PATH = ['~/.stormmq','/etc']
  SECRET_KEYS_FILENAME    = 'secret-keys.json'

  class SecretKeys
    include Singleton
    attr_writer :key_cache

    def key_for(user)
      keys[user]
    end

    def users
      keys.keys
    end

    private

    def keys
      @keys_cache ||= load_secret_keys
    end

    def load_secret_keys(search_path=SECRET_KEYS_SEARCH_PATH, keyfile=SECRET_KEYS_FILENAME)
      full_paths = search_path.map{|p| File.expand_path("#{p}/#{keyfile}")}
      full_paths.each do |full_path|
        begin
          return StormMQ::SecretKeys.secret_keys_hash_from_json(IO.read(full_path))
        rescue
        end
      end
      raise StormMQ::Error::LoadSecretKeysError,
          "Could not read the secret keys file from any of [#{full_paths.join ', '}]. Please ensure that a valid keyfile exists in one of these locations and that it is readable.",
          caller
    end

    def self.secret_keys_hash_from_json(json_string)
      hash = JSON.parse(json_string)
      hash.values.each {|v| v.tr!("-_","+/")}
      hash
    end

  end

end