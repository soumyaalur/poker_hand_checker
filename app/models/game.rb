class Game
    attr_accessor :cards

    def initialize
     @cards = {}
     initialize_cards
    end

    def initialize_cards
        Card::FACES.keys.each do|face|
            Card::SUITES.each do|suite|
                @cards["#{face}#{suite}"] = Card.new(face, suite)
            end
        end
        @cards["#{Card::JOKER}#{Card::JOKER}"] = Card.new(Card::JOKER, Card::JOKER)
    end
end