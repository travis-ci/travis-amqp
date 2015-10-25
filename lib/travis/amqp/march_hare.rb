require 'march_hare'

module Travis
  module Amqp
    require 'travis/amqp/march_hare/consumer'
    require 'travis/amqp/march_hare/publisher'

    class << self
      def setup(config)
        @config = config.to_h
        self
      end

      def config
        @config
      end

      def connected?
        !!@connection
      end

      def connection
        @connection ||= MarchHare.connect(config)
      end
      alias :connect :connection

      def disconnect
        if connection
          connection.close if connection.isOpen
          @connection = nil
        end
      end
    end
  end
end
