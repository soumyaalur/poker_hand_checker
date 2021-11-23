# frozen_string_literal: true

class Poker
  attr_accessor :selected_cards, :has_ace

  def initialize(selected_cards)
    @selected_cards = selected_cards
    # Find if A present
    @has_ace = ace?
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  def evaluate
    return {label: 'Five of a kind', rank: 1} if n_of_kind?(5)
    return {label: 'Straight flush', rank: 2} if straight_flush?
    return {label: 'Four_of_kind', rank: 3} if n_of_kind?(4)
    return {label: 'Full house', rank: 4} if full_house?
    return {label: 'Flush', rank: 5} if flush?
    return {label: 'Straight', rank: 6} if straight?
    return {label: 'Three of a Kind', rank: 7} if n_of_kind?(3)
    return {label: 'Two pair', rank: 8} if two_pairs?
    return {label: 'One pair', rank: 9} if n_of_kind?(2)

    {label: "Highest card: #{high_card}", rank: 10}
  end
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity

  def ace?
    selected_cards.each do |card|
      return true if card.face == 'A'
    end
    false
  end

  def group_by_selected_cards_face
    selected_cards.group_by(&:face)
  end

  def group_by_selected_cards_suit
    selected_cards.group_by(&:suite)
  end

  def n_of_kind?(target_size)
    group = group_by_selected_cards_face
    group.any? { |_, values| target_size == values.count }
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
    n_of_kind?(3) && n_of_kind?(2)
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

  def sequence?(face_values)
    return false if face_values.length != 5

    sorted_values = face_values.sort
    start = sorted_values[0]
    (start...start + 5).to_a
    sorted_values == (start...start + 5).to_a
  end

  def high_card
    return 'A' if has_ace

    begin
      selected_cards.max_by { |card| Card::FACES[card.face] }.face
    rescue StandardError
      nil
    end
  end
end
