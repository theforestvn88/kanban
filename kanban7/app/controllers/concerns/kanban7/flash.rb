# frozen_string_literal: true

module Kanban7
    module Flash
        extend ActiveSupport::Concern

        def flash_error(error_message, status:)
            render partial: "kanban7/error_flash", formats: [:turbo_stream], locals: { error_message: error_message }, status: status
        end
    end
end
