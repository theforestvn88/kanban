require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
    context "turbo stream" do

        let(:turbo_stream) { double }

        before do
            allow(turbo_stream).to receive(:update)
            allow(helper).to receive(:turbo_stream).and_return(turbo_stream)
        end

        it "clear modal" do
            helper.clear_modal
            expect(turbo_stream).to have_received(:update).with("modal", "")
        end

        it "show flash if any" do
            allow(helper).to receive(:flash).and_return([{type: "notice", message: "???"}])

            helper.show_flash_if_any
            expect(turbo_stream).to have_received(:update).with("flash", {partial: "shared/flash"})
        end

        it "not show flash if not any" do
            allow(helper).to receive(:flash).and_return([])

            helper.show_flash_if_any
            expect(turbo_stream).not_to have_received(:update).with("flash", {partial: "shared/flash"})
        end
    end
end
