require './spec/test_helper'

puts "this test requires the rabbit mq broker to be running at localhost:5672 and some other publishing system to publish a message"
puts "waiting for a message..."

module Report
    class Event
        attr_reader :name, :type, :created_at, :data, :id

        def initialize(data)
            @name = data['name']
            @id = data['entity_id']
            @data = data['data']
            @created_at = Time.parse(data['created_at'])
            @type = data['entity_type']
        end
    end

    class Listener
        def initialize(bunny_connection)
            @conn = bunny_connection
            @channel = @conn.create_channel
            @exchange = @channel.fanout('test.events')
            @queue = @channel.queue('', exclusive: false, auto_delete: true)
        end

        def on_payload(&block)
            @callback = block
        end

        def listen
            @queue.subscribe(consumer_tag: 'test_listener', block: false, ack: true) do |info, properties, payload|
                event = Report::Event.new(JSON.parse(payload))
                @callback.call(event)
            end

            @queue.bind(@exchange)
        end
    end
end

message_received = false

conn = Bunny.new('amqp://guest:guest@localhost:5672')
conn.start

ch = conn.create_channel
ex = ch.fanout('test.events')

created_at = Time.now

listener = Report::Listener.new(conn)
listener.on_payload do |event|
    puts 'message received'
    message_received = true

    raise unless event.name == 'change_name'
    raise unless event.id == '12345'
    raise unless event.data == ['new name']
    raise unless event.type == 'client'
    raise unless event.created_at.to_s == created_at.to_s
end

listener.listen
event = {
    name: 'change_name',
    entity_id: '12345',
    data: ['new name'],
    created_at: created_at,
    entity_type: 'client'
}.to_json

# comment next line and set sleep to 10 if you want to test with other app publishing
ex.publish(event)
sleep 1

raise 'no message received' unless message_received
puts 'all good!'

