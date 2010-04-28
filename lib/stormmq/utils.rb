module StormMQ
  module Utils
    def self.stormmq_credentials_string(user, password)
      "\0#{user}\0#{password}"
    end
  end
end