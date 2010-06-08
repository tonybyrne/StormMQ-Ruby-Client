#--
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.
#++


require 'bunny'
require 'stormmq/version'

module StormMQ

  module AMQPClient

    def self.instance(options={})
      Bunny.new(self.add_stormmq_options(options))
    end

    def self.run(options={}, &block)
      Bunny.run(self.add_stormmq_options(options), &block)
    end

    def self.add_stormmq_options(options={})
      {
        :vhost   => self.vhost_from_options(options),
        :host    => 'amqp.stormmq.com',
        :port    => 443,
        :ssl     => true
      }.merge(options)
    end

    def self.vhost_from_options(options)
      vhost = "/#{options[:company]}/#{options[:system]}/#{options[:environment]}"
      [:company, :system, :environment].each {|option| options.delete(option)}
      vhost
    end

  end

end

