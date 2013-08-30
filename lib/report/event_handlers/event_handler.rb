module Report
    module Handlers
        class EventHandler
            def initialize(db)
                @db = db
            end

            def accepts?(event)
                self.respond_to?(event.name) && can_handle?(event.type)
            end

            def process(event)
                self.send(event.name, *[event.id, event.data])
            end
        end
    end
end
