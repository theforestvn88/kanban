module Kanban    
    class CardDrop < ::BaseService
        include DragAndDrop

        def initialize(drag_card_id:, drop_card_id:)
            @drag_card_id = drag_card_id
            @drop_card_id = drop_card_id
        end

        Result = Struct.new(:success, :drag_card, :drop_card, :error)

        def call
            result = nil
            ActiveRecord::Base.transaction do
                @drag_card = Card.find(@drag_card_id)
                @drop_card = Card.find(@drop_card_id)
                
                validate!(@drag_card, @drop_card)

                update_position(@drag_card, @drop_card)

                # move drag card into drop-card's list
                @drag_card.list_id = @drop_card.list_id
                
                @drag_card.save!
                @drop_card.save!

                result = Result.new(success: true, drag_card: @drag_card, drop_card: @drop_card)
            end

            result
        rescue => e
            Result.new(success: false, error: e)
        end

        private

            attr_reader :drag_card_id, :drop_card_id
    end
end
