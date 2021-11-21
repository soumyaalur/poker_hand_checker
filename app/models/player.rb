# frozen_string_literal: true

class Player
  attr_accessor :game, :player_cards, :selected_cards

  def initialize(player_cards)
    @player_cards = player_cards
    @game = Game.new
    @selected_cards = []
  end

  def play
    errors = validate_cards
    raise errors.join(', ') if errors.present?

    Poker.new(@selected_cards).evaluate
  end

  private

  def validate_cards
    errors = []
    player_cards.each do |card_value|
      errors << "Invalid card #{card_value}" and next unless @game.cards.key?(card_value)
      errors << "Duplicate card #{card_value}" and next if @game.cards[card_value].nil?

      @selected_cards << @game.cards[card_value]
      @game.cards[card_value] = nil
    end
    errors
  end
end
