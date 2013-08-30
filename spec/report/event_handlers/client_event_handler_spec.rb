require 'spec_helper'

describe 'change_name event handling' do
    let (:event) do
        event_data = {
            name: 'change_name',
            entity_id: '12345',
            data: ['new name'],
            created_at: Time.now.to_s,
            entity_type: 'client'
        }

        Report::Event.new(event_data)
    end

    let! (:db) {Sequel.sqlite}
    let (:handler) {Report::Handlers::Client::NameChangeEventHandler.new(db)}

    it 'should accept the event' do
        handler.accepts?(event).should == true
    end

    it 'should not accept the event if the name does not match an existing method' do
        other_data = {name: 'change_balance', entity_id: '123', data: [], created_at: Time.now.to_s, entity_type: 'client'}
        other_event = Report::Event.new(other_data)
        handler.accepts?(other_event).should == false
    end

    it 'should not accept other events types' do
        other_data = {name: 'some_name', entity_id: '123', data: [], created_at: Time.now.to_s, entity_type: 'user'}
        other_event = Report::Event.new(other_data)
        handler.accepts?(other_event).should == false
    end

    it 'should change the name of the client' do
        db.create_table :clients do
            primary_key :id
            String :name
            String :uid
        end

        db[:clients].insert(name: 'old name', uid: event.id)

        handler.process(event)

        clients = db[:clients].where(uid: event.id)
        clients.count.should == 1
        clients.first[:name].should == event.data[0]
    end
end
