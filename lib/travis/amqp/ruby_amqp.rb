# frozen_string_literal: true

require 'amqp'
require 'amqp/utilities/event_loop_helper'

module Travis
  module Amqp
    require 'travis/amqp/ruby_amqp/consumer'
    require 'travis/amqp/ruby_amqp/publisher'

    class << self
      def setup(config)
        send(:config=, config.to_h, false)
      end

      attr_reader :config

      def config=(config, deprecated: true)
        puts 'Calling Travis::Amqp.config= is deprecated. Call Travis::Amqp.setup(config) instead.' if deprecated
        @config = config
      end

      def connected?
        !!@connection
      end

      def connection
        @connection ||= begin
          AMQP::Utilities::EventLoopHelper.run
          AMQP.start(config) do |conn, _open_ok|
            conn.on_tcp_connection_loss do |con, _settings|
              puts '[network failure] Trying to reconnect...'
              con.reconnect(false, 2)
            end
          end
        end
      end
      alias connect connection

      def disconnect
        return unless connection

        connection.close if connection.open?
        @connection = nil
      end
    end
  end
end
