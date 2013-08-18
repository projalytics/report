require './spec/test_helper'

puts "this test requires the rabbit mq broker to be running at localhost:5672 and some other publishing system to publish a message"
puts "waiting for a message..."

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

