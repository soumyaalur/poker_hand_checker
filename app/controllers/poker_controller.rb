# frozen_string_literal: true

class PokerController < ApplicationController
  before_action :set_cards

  def play_poker; end

  def evaluate_cards
    begin
      @previous_selections = card_params
      selected_cards = card_params.values
      player = Player.new(selected_cards)
      @result = player.play
    rescue StandardError => e
      @errors = e
    end

    render :play_poker
  end

  private

  def card_params
    params.require(:cards).permit(:card1, :card2, :card3, :card4, :card5)
  end

  def set_cards
    @cards = all_cards
    @previous_selections = {}
  end

  def all_cards
    cards = []
    Card::FACES.each_key do |face|
      Card::SUITES.each do |suit|
        cards << ["#{face}#{suit}", "#{face}#{suit}"]
      end
    end
    cards
  end
end
