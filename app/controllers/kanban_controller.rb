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
end
