class CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list, only: [:new, :create]
  before_action :set_card, only: %i[ show edit update destroy ]

  def show
  end

  def new
    @card = Card.new(list: @list)
  end

  def create
    @card = Card.new(card_params.merge(list: @list, user: current_user))

    respond_to do |format|
      if @card.save
        format.turbo_stream { flash.now[:notice] = "Your new card was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @card.update(card_params)
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @card.destroy!

    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Your card was destroyed." }
    end
  end

  private
    
    def set_card
      @card = Card.find(params[:id])
    end

    def set_list
      @list = List.find(params[:list_id])
    end

    def card_params
      params.require(:card).permit(:title, :description)
    end
end
