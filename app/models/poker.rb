# frozen_string_literal: true

class Poker
  attr_accessor :selected_cards, :has_ace

  def initialize(selected_cards)
    @selected_cards = selected_cards
    # Find if A present
    @has_ace = ace?
  end

  def ace?
    selected_cards.each do |card|
      return true if card.face == 'A'
    end
    false
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  def evaluate
    return 'Five of a Kind' if n_of_kind(5)
    return 'Straight flush' if straight_flush?
    return 'Four of a Kind' if n_of_kind(4)
    return 'Full house' if full_house?
    return 'Flush' if flush?
    return 'Straight' if straight?
    return 'Three of a Kind' if n_of_kind(3)
    return 'Two pair' if two_pairs?
    return 'one pair' if n_of_kind(2)

    "Highest card: #{high_card}"
  end
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity

  def group_by_selected_cards_face
    selected_cards.group_by(&:face)
  end

  def group_by_selected_cards_suit
    selected_cards.group_by(&:suite)
  end

  def n_of_kind(target_size)
    group = group_by_selected_cards_face
    group.each do |_k, values|
      return true if target_size == values.count
    end
    false
  end

  def two_pairs?
    group = group_by_selected_cards_face
    pairs = 0
    group.each do |_k, values|
      pairs += 1 if values.count == 2
    end

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
    return sequence?(face_values(selected_cards)) unless has_ace

    cards = selected_cards.reject { |card| card.face == 'A' }
    face_values = face_values(cards)
    sequence?([1] + face_values) || sequence?(face_values + [14])
  end

  def face_values(cards)
    cards.map { |card| Card::FACES[card.face] }
  end

  def sequence?(cards)
    sorted_cards = cards.sort
    start = sorted_cards[0]
    (start...start + 5).to_a
    sorted_cards == (start...start + 5).to_a
  end

  def high_card
    return 'A' if has_ace

    selected_cards.max_by { |card| Card::FACES[card.face] }.face
  end
end
