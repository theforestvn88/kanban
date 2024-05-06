class BoardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_board, only: [:edit, :update, :destroy]

  def index
    @current_user_boards = current_user.boards
  end

  def show
    session[:current_board] = params[:id]
    set_board
  rescue ActiveRecord::RecordNotFound => e
    session[:current_board] = nil
    redirect_to root_path
  end

  def new
    @board = Board.new
  end

  def create
    @board = Board.new(user: current_user, **board_params)

    respond_to do |format|
      if @board.save
        format.turbo_stream { flash.now[:notice] = "Your new board was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @board.update(board_params)
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @board.destroy

    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Your board was destroyed." }
    end
  end

  private

    def board_params
      params.require(:board).permit(:name)
    end

    def set_board
      @board = Board.find(params[:id])
    end
end
