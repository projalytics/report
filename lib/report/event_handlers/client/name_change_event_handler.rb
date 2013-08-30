module Report
    module Handlers
        module Client
            class NameChangeEventHandler < Report::Handlers::EventHandler
                def change_name(uid, new_name)
                    @db[:clients].where(uid: uid).update(name: new_name)
                end

                private

                def can_handle?(type)
                    type == :client 
                end
            end
        end
    end
end

