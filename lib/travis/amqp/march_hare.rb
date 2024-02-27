# frozen_string_literal: true

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

      attr_reader :config

      def connected?
        !!@connection
      end

      def connection
        @connection ||= MarchHare.connect(config)
      end
      alias connect connection

      def disconnect
        return unless connection

        connection.close if connection.isOpen
        @connection = nil
      end
    end
  end
end
