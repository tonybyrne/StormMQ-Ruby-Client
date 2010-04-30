#--
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.
#++

require 'mq'
require 'pp'

module StormMQ

  module AMQPClientImplementation

    VERSION = '0.0.2'

    def process_frame frame
      if mq = channels[frame.channel]
        mq.process_frame(frame)
        return
      end

      case frame
      when Frame::Method
        case method = frame.payload
        when Protocol::Connection::Start
          send Protocol::Connection::StartOk.new(
            {
              :platform    => 'Ruby/EventMachine',
              :product     => 'StormMQ AMQP',
              :information => 'http://github.com/tonybyrne/StormMQ-Ruby-Client/',
              :version     => VERSION
            },
            'AMQPLAIN',
            Utils.stormmq_credentials_string(@settings[:user], @settings[:password]),
            'en_US'
          )

        when Protocol::Connection::Tune
          send Protocol::Connection::TuneOk.new(
            :channel_max => 0,
            :frame_max   => 131072,
            :heartbeat   => 0
          )

          send Protocol::Connection::Open.new(
            :virtual_host => @settings[:vhost],
            :capabilities => '',
            :insist       => @settings[:insist]
          )

        when Protocol::Connection::OpenOk
          succeed(self)

        when Protocol::Connection::Close
          STDERR.puts "#{method.reply_text} in #{Protocol.classes[method.class_id].methods[method.method_id]}"

        when Protocol::Connection::CloseOk
          @on_disconnect.call if @on_disconnect
        end
      end
    end
  end

  module AMQPClient

    def self.connect(options={})
      AMQP.client = AMQPClientImplementation
      AMQP.connect(
        {
          :vhost   => self.vhost_from_options(options),
          :host    => 'amqp.stormmq.com',
          :port    => 443,
          :ssl     => true
        }.merge(options)
      )
    end

    def self.vhost_from_options(options)
      vhost = "/#{options[:company]}/#{options[:system]}/#{options[:environment]}"
      [:company, :system, :environment].each {|option| options.delete(option)}
      vhost
    end

  end

end

