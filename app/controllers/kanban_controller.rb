class KanbanController < ApplicationController
  def index
    if user_signed_in?
      if session[:current_board]
        redirect_to board_path(session[:current_board])
      else
        redirect_to boards_path
      end
    end
  end

  def dad_card
    return if params[:type] != 'card'

    result = Kanban::CardDrop.call(drag_card_id: params[:drag_id], drop_card_id: params[:drop_id])

    respond_to do |format|
      if result.success
        @drag_card = result.drag_card
        @drop_card = result.drop_card

        format.turbo_stream
      else
        format.turbo_stream { head :forbidden }
      end
    end
  end
end
