require 'bunny'

module Report
    class App
        def initialize
            Signal.trap('TERM') do
                $stdout.puts "TERM signal caught. Exiting..."

                exit 0
            end

            register_event_handlers
        end

        def start
            $stdout.puts "opening rmq connection..."
            begin
                conn = Bunny.new('amqp://guest:guest@localhost:5672')
                conn.start
            rescue e
                $stderr.puts "error opening rmq connection\n #{e.caller}"
            end

            $stdout.puts "connecting to rmq broker..."
            begin
                rmq = Report::Listener::RMQInitializer.new(conn)
                listener = Report::Listener.new(rmq)
            rescue e
                $stderr.puts "error creating a listener\n #{e.caller}"
            end

            listener.on_payload do |event|
                $stdout.puts 'event received'
                $stdout.puts '--------------'
                $stdout.puts event.inspect


                $stdout.flush
            end

            listener.listen
            $stdout.flush

            while true do
            end
        end

        private 

        def register_event_handlers
            @event_handlers = {}
        end
    end
end
