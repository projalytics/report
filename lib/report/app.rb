module Report
    class App
        def initialize
            Signal.trap('TERM') do
                $stdout.puts "TERM signal caught. Exiting..."

                exit 0
            end
        end

        def listen
            puts 'listening forever'
            while true
            end
        end
    end
end
