require 'spec_helper'

describe 'change_name event handling' do
    let (:event) do
        event_data = {
            name: 'change_name',
            entity_id: '12345',
            data: ['new name'],
            created_at: Time.now,
            entity_type: 'client'
        }

        Report::Event.new(event_data)
    end

    let (:handler) {Report::Handlers::ClientEventHandler.new}

    it 'should accept the event' do
        handler.accepts?(event).should == true
    end

    it 'should not accept other events' do
        other_data = {name: 'some_name', entity_id: '123', data: [], created_at: Time.now, entity_type: 'user'}
        other_event = Report::Event.new(other_data)
        handler.accepts?(event).should == false
    end

    it 'should change the name of the client' do
        client = Factory.create(:client, {uid: '12345', name: 'old name'})
        handler.process(event)

        client.reload
        client.name.should == event.data.first
    end
end
