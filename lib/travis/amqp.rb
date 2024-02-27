# frozen_string_literal: true

adapter = RUBY_PLATFORM == 'java' ? 'march_hare' : 'bunny'
require "travis/amqp/#{adapter}"

Travis::Amqp::Consumer.class_eval do
  class << self
    def jobs(routing_key, options = {})
      options = deep_merge({ exchange: { name: 'reporting' } }, options)
      new("reporting.jobs.#{routing_key}", options)
    end

    def deep_merge(hash, other)
      hash.merge(other, &(merger = proc { |_key, v1, v2|
                            v1.is_a?(Hash) && v2.is_a?(Hash) ? v1.merge(v2, &merger) : v2
                          }))
    end
  end
end

Travis::Amqp::Publisher.class_eval do
  class << self
    def builds(routing_key)
      new(routing_key)
    end

    def jobs(routing_key)
      new("reporting.jobs.#{routing_key}", type: 'topic', name: 'reporting')
    end
  end
end
