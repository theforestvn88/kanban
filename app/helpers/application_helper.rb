module ApplicationHelper
    def clear_modal
        turbo_stream.update "modal", ""
    end

    def show_flash_if_any
        turbo_stream.update "flash", partial: "shared/flash" if flash.any?
    end
end
