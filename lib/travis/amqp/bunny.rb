module Travis
  module Amqp
    require 'travis/amqp/bunny/publisher'
    require 'travis/amqp/bunny/consumer'

    class << self
      def setup(config)
        send(:config=, config.to_h, false)
        self
      end

      attr_reader :config, :options

      def config=(config, deprecated = true)
        puts 'Calling Travis::Amqp.config= is deprecated. Call Travis::Amqp.setup(config) instead.' if deprecated

        config = config.dup
        config[:user] = config.delete(:username) if config[:username]
        config[:pass] = config.delete(:password) if config[:password]

        if config.key?(:tls)
          config[:ssl] = true
          config[:tls] = true
        end

        @config = config

        @options = {}
        @options[:spec] = config.delete(:spec) if config[:spec]
      end

      def connected?
        !!@connection
      end

      def connection
        @connection ||=  begin
          require 'bunny'
          bunny = Bunny.new(config, options)
          bunny.start
          bunny
        end
      end
      alias :connect :connection

      def disconnect
        if connection
          connection.close if connection.open?
          @connection = nil
        end
      end
    end
  end
end
