require 'time'

module Report
    class Event
        attr_reader :name, :type, :created_at, :data, :id

        def initialize(data)
            @name = data[:name]
            @id = data[:entity_id]
            @data = data[:data]
            @created_at = Time.parse(data[:created_at])
            @type = data[:entity_type].to_sym
        end
    end
end
