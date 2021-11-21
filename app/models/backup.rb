class Poker

    attr_accessor :selected_cards, :has_joker, :has_ace

    def initialize(selected_cards)
        @selected_cards = selected_cards
        # Find if joker present
        @has_joker = has_joker?
        # Find if A present
        @has_ace = has_ace?
    end

    def has_joker?
        selected_cards.each do |card|
            if Card::JOKER == card.face
                selected_cards.delete(card)
                return true
            end
        end

        false
    end

    def has_ace?
        selected_cards.each do |card|
            return true if 'A' == card.face
        end
        false
    end

    def evaluate(selected_cards)
        return "Five of a Kind" if n_of_kind(5)
        return "Straight flush" is straight_flush?
        return "Four of a Kind" if n_of_kind(4)
        return "Full house" if full_house?
        return "Flush" if flush?
        return "Straight" if straight?
        return "Three of a Kind" if n_of_kind(3)
        return "Two pair" if two_pairs?()
        return "one pair" if n_of_kind(1)

        "Highest card: #{high_card}"
    end

    def group_by_selected_cards_face()
        selected_cards.group_by {|card| card.face}
    end

    def group_by_selected_cards_suit()
        selected_cards.group_by {|card| card.suite}
    end

    def n_of_kind(target_size)
        group = group_by_selected_cards_face()
        count = has_joker ? 1 : 0
        group.each do|k, values|
            return true if target_size == count + values.count
        end
        false
    end

    def two_pairs?()
        group = group_by_selected_cards_face()
        pairs = 0
        group.each do|k, values|
            pairs += 1 if 2 == values.count
        end

        return true if pairs == 1 && has_joker

        pairs == 2
    end

    def full_house?
        n_of_kind(3) && n_of_kind(2)
    end

    def straight_flush?
        straight? && flush?
    end

    def flush?
       group = group_by_selected_cards_suit
       group.size == 1
    end

    def straight?
        if has_ace
            cards = selected_cards.reject {|card| card.face == "A"}
            is_sequence?(["A"] + cards) || is_sequence?(cards + ["A"])
        elsif !has_joker
            is_sequence?(selected_cards)
        end
    end

    def is_sequence?(cards)
        sorted_cards = cards.sort_by {|card| Card::FACES[card.face] }
        start = sorted_cards[0]
        sorted_cards == (start...start+5)
    end

    def high_card
        return 'A' if has_ace

        selected_cards.sort_by {|card| Card::FACES[card.face]}[-1]
    end
end

