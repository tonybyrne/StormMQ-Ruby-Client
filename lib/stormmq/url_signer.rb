module StormMQ

  class URLSigner

    def self.sign(url, options={})
      secret_key   = StormMQ::SecretKeys.instance.key_for(options[:user])
      original_url = StormMQ::URL.new(url)

      if options.delete(:compact)
        url_with_user_and_version = original_url.add_user_and_version_query_params(options[:user], 0)
        signature                 = url_with_user_and_version.canonicalise.signature(secret_key, options[:method])
        url_with_user_and_version.add_query_params('signature' => signature)
      else
        original_url.add_user_and_version_query_params(options[:user], 0).canonicalise.sign(secret_key, options[:method])
      end
    end

  end

end