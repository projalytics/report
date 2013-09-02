require 'spec_helper'

describe Report::Listener do
    it 'should use the right event handler to process messages' do
        conn = double('rmq-connection')
        listener = Report::Listener.new(conn)
    end
end
