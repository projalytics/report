require 'bunny'
require 'json'

module Report
    class Listener
        class RMQInitializer
            attr_reader :conn, :channel, :exchange, :queue

            def initialize(bunny_connection)
                @conn = bunny_connection
                @channel = @conn.create_channel
                @exchange = @channel.fanout('test.events')
                @queue = @channel.queue('', exclusive: false, auto_delete: true)
            end

            def bind_queue
                @queue.bind(@exchange)
            end
        end

        def initialize(rmq_initializer)
            @rmq = rmq_initializer
        end

        def on_payload(&block)
            @callback = block
        end

        def listen
            @rmq.queue.subscribe(consumer_tag: 'test_listener', block: false, ack: true) do |info, properties, payload|
                event = Report::Event.new(JSON.parse(payload))
                @callback.call(event)
            end

            @rmq.bind_queue
        end
    end
end
