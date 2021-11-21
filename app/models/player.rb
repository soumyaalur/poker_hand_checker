class Player
    attr_accessor :game, :player_cards, :selected_cards
    def initialize(player_cards)
        @player_cards = player_cards
        @game = Game.new
        @selected_cards = []

    end

    def play
       errors = validate_cards
       if errors.empty? 
            Poker.new(@selected_cards).evaluate()
       else
           raise errors.join(", ")
       end
    end

    private 

    def validate_cards
        errors = []
        player_cards.each do |card_value|
            if @game.cards.has_key?(card_value)
                if @game.cards[card_value].nil?
                    errors << "Duplicate card #{card_value}"
                else
                    @selected_cards << @game.cards[card_value]
                    @game.cards[card_value] = nil
                end
            else    
                errors << "Invalid card #{card_value}"
            end
        end
        errors
    end
end

