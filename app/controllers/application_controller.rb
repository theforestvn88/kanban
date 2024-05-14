class ApplicationController < ActionController::Base
    private

        def current_user_session
            session[current_user.id] ||= {}
        end
end
