# frozen_string_literal: true

module Travis
  module Amqp
    class Consumer
      DEFAULTS = {
        subscribe: { ack: false, blocking: false },
        queue: { durable: true, exclusive: false },
        channel: { prefetch: 1 },
        exchange: { name: nil, routing_key: nil }
      }.freeze

      attr_reader :name, :options, :subscription

      def initialize(name, options = {})
        @name    = name
        @options = deep_merge(DEFAULTS, options)
      end

      def subscribe(options = {}, &block)
        options = deep_merge(self.options[:subscribe], options)
        # logger.debug "subscribing to #{name.inspect} with #{options.inspect}"
        @subscription = queue.subscribe(options, &block)
      end

      def unsubscribe
        # logger.debug "unsubscribing from #{name.inspect}"
        subscription.cancel if subscription.try(:active?)
      end

      protected

      def queue
        @queue ||= channel.queue(name, options[:queue]).tap do |queue|
          if options[:exchange][:name]
            routing_key = options[:exchange][:routing_key] || name
            queue.bind(options[:exchange][:name], routing_key:)
          end
        end
      end

      def channel
        Amqp.connection.create_channel.tap do |channel|
          channel.prefetch = options[:channel][:prefetch] || DEFAULTS[:channel][:prefetch]
        end
      end

      def deep_merge(hash, other)
        hash.merge(other, &(merger = proc { |_key, v1, v2|
                              v1.is_a?(Hash) && v2.is_a?(Hash) ? v1.merge(v2, &merger) : v2
                            }))
      end
    end
  end
end
