class ListsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_board, only: [:new, :create]
    before_action :set_list, except: [:new, :create]

    def new
        @list = List.new(board: @board)
    end
    
    def create
        @list = List.new(list_params.merge(user: current_user, board: @board))
        
        respond_to do |format|
            if @list.save
                format.turbo_stream { flash.now[:notice] = "Your new list was successfully created." }
            else
                format.html { render :new, status: :unprocessable_entity }
            end
        end
    end

    def edit
    end

    def update
        respond_to do |format|
            if @list.update(list_params)
                format.turbo_stream
            else
                format.html { render :edit, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @list.destroy

        respond_to do |format|
            format.turbo_stream { flash.now[:notice] = "Your list was destroyed." }
        end
    end

    def actions
    end

    def move
        @step = params[:step].to_i
        list_position = @list.position
        if @step > 0
            @next_list = @list.board.lists.where('position > ?', list_position).first
            return if @next_list.nil?

            @list.update!(position: @next_list.position)
            @next_list.update!(position: list_position)
        else
            @prev_list = @list.board.lists.where('position < ?', list_position).last
            return if @prev_list.nil?

            @list.update!(position: @prev_list.position)
            @prev_list.update!(position: list_position)
        end
    end

    private

        def set_board
            @board = Board.find(params[:board_id])
        end

        def set_list
            @list = List.find(params[:id])
        end

        def list_params
            params.require(:list).permit(:name)
        end
end
