# frozen_string_literal: true

require 'rails_helper'

describe Poker do
  describe '#flush?' do
    let(:valid_flush) do
      [
        Card.new('2', 'C'),
        Card.new('10', 'C'),
        Card.new('3', 'C'),
        Card.new('9', 'C'),
        Card.new('10', 'C')
      ]
    end

    let(:invalid_flush) do
      [
        Card.new('2', 'C'),
        Card.new('10', 'D'),
        Card.new('3', 'C'),
        Card.new('9', 'H'),
        Card.new('10', 'C')
      ]
    end

    it 'checks wether its valid flush' do
      poker = Poker.new(valid_flush)
      expect(poker.flush?).to be_truthy
    end

    it 'checks wether its invalid flush' do
      poker = Poker.new(invalid_flush)
      expect(poker.flush?).to be_falsy
    end
  end

  describe '#sequence?' do
    let(:check_sequence) do
      [
        Card.new('A', 'C'),
        Card.new('J', 'C'),
        Card.new('K', 'C'),
        Card.new('Q', 'C'),
        Card.new('10', 'C')
      ]
    end

    it 'returns true if the cards are sequential' do
      poker = Poker.new(check_sequence)
      expect(poker.sequence?([1, 2, 3, 4, 5])).to be_truthy
    end

    it 'returns false when the values are not sequential' do
      poker = Poker.new(check_sequence)
      expect(poker.sequence?([1, 2, 6, 7, 9])).to be_falsy
    end

    it 'returns false if count of values are less than 5' do
      poker = Poker.new(check_sequence)
      expect(poker.sequence?([1])).to be_falsy
    end

    it 'returns false if count of values are more than 5' do
      poker = Poker.new(check_sequence)
      expect(poker.sequence?([1, 2, 3, 4, 5, 6])).to be_falsy
    end
  end

  describe '#straight?' do
    let(:valid_staright) do
      [
        Card.new('A', 'C'),
        Card.new('J', 'C'),
        Card.new('K', 'C'),
        Card.new('Q', 'C'),
        Card.new('10', 'C')
      ]
    end

    let(:invalid_staright) do
      [
        Card.new('A', 'C'),
        Card.new('9', 'C'),
        Card.new('K', 'C'),
        Card.new('Q', 'C'),
        Card.new('10', 'C')
      ]
    end

    let(:valid_staright_with_low_ace) do
      [
        Card.new('A', 'C'),
        Card.new('3', 'C'),
        Card.new('2', 'C'),
        Card.new('5', 'C'),
        Card.new('4', 'C')
      ]
    end

    it 'returns true if it is a valid straight' do
      poker = Poker.new(valid_staright)
      expect(poker.straight?).to be_truthy
    end

    it 'returns true if it is a sequence with low ace' do
      poker = Poker.new(valid_staright_with_low_ace)
      expect(poker.straight?).to be_truthy
    end

    it 'returns false if it is not a sequence' do
      poker = Poker.new(invalid_staright)
      expect(poker.straight?).to be_falsy
    end
  end

  describe '#straight_flush?' do
    let(:valid_straight_flush_cards) do
      [
        Card.new('A', 'C'),
        Card.new('2', 'C'),
        Card.new('3', 'C'),
        Card.new('4', 'C'),
        Card.new('5', 'C')
      ]
    end

    it 'returns true if the cards are sequential and has same suit' do
      poker = Poker.new(valid_straight_flush_cards)
      expect(poker.straight_flush?).to be_truthy
    end

    it 'calls straight? and flush? is cards valid straight flush' do
      poker = Poker.new(valid_straight_flush_cards)
      expect(poker).to receive(:straight?).and_return(true)
      expect(poker).to receive(:flush?).and_return(true)

      poker.straight_flush?
    end

    it "doesn't call flush? is it's not straight" do
      poker = Poker.new(valid_straight_flush_cards)
      expect(poker).to receive(:straight?).and_return(false)
      expect(poker).to_not receive(:flush?)

      poker.straight_flush?
    end
  end

  describe '#high_card' do
    let(:ace_high_card) do
      [
        Card.new('A', 'D'),
        Card.new('J', 'C'),
        Card.new('K', 'H'),
        Card.new('Q', 'S'),
        Card.new('10', 'C')
      ]
    end

    let(:highest_card) do
      [
        Card.new('2', 'C'),
        Card.new('9', 'D'),
        Card.new('K', 'C'),
        Card.new('6', 'H'),
        Card.new('10', 'C')
      ]
    end

    it "returns 'A' if selected cards has ace" do
      poker = Poker.new(ace_high_card)
      expect(poker.high_card).to be_truthy
    end

    it 'returns highest card of all' do
      poker = Poker.new(highest_card)
      expect(poker.high_card).to eq('K')
    end

    it 'returns nil if the card is invalid' do
      highest_card[0] = Card.new('1', 'C')
      poker = Poker.new(highest_card)
      expect(poker.high_card).to be_nil
    end
  end

  describe '#n_of_kind?' do
    let(:target) do
      [
        Card.new('A', 'C'),
        Card.new('A', 'D'),
        Card.new('A', 'S'),
        Card.new('A', 'H'),
        Card.new('A', 'C')
      ]
    end

    it 'returns true if target size is equal to count' do
      poker = Poker.new(target)
      expect(poker.n_of_kind?(5)).to be_truthy
    end

    it 'returns false when the count is not equal to the target size' do
      poker = Poker.new(target)
      expect(poker.n_of_kind?(2)).to be_falsy
    end
  end

  describe '#two_pairs?' do
    let(:valid_two_pairs) do
      [
        Card.new('2', 'C'),
        Card.new('9', 'D'),
        Card.new('2', 'C'),
        Card.new('6', 'H'),
        Card.new('6', 'S')
      ]
    end

    let(:invalid_two_pairs) do
      [
        Card.new('2', 'C'),
        Card.new('9', 'D'),
        Card.new('2', 'C'),
        Card.new('6', 'H'),
        Card.new('10', 'S')
      ]
    end

    it 'returns true if there are two pairs ' do
      poker = Poker.new(valid_two_pairs)
      expect(poker.two_pairs?).to be_truthy
    end

    it 'returns false if it has less than two pairs' do
      poker = Poker.new(invalid_two_pairs)
      expect(poker.two_pairs?).to be_falsy
    end

    it 'returns false if it has more than two pairs' do
      valid_two_pairs << Card.new('9', 'S')
      poker = Poker.new(invalid_two_pairs)
      expect(poker.two_pairs?).to be_falsy
    end
  end

  describe '#full_house?' do
    let(:valid_full_house) do
      [
        Card.new('2', 'C'),
        Card.new('2', 'D'),
        Card.new('2', 'S'),
        Card.new('6', 'H'),
        Card.new('6', 'S')
      ]
    end
    it 'returns true if it has a three of one kind and two of one kind' do
      poker = Poker.new(valid_full_house)
      expect(poker.full_house?).to be_truthy
    end

    it 'calls n_of_kind?(3) and n_of_kind?(2) cards are valid full_house' do
      poker = Poker.new(valid_full_house)
      expect(poker).to receive(:n_of_kind?).with(3).and_return(true)
      expect(poker).to receive(:n_of_kind?).with(2).and_return(true)

      poker.full_house?
    end

    it "doesn't calls n_of_kind?(2) when n_of_kind?(3) return false" do
      poker = Poker.new(valid_full_house)
      expect(poker).to receive(:n_of_kind?).with(3).and_return(false)
      expect(poker).to_not receive(:n_of_kind?)

      poker.full_house?
    end
  end

  describe '#ace?' do
    let(:ace) do
      [
        Card.new('A', 'D'),
        Card.new('J', 'C'),
        Card.new('K', 'H'),
        Card.new('Q', 'S'),
        Card.new('10', 'C')
      ]
    end

    let(:not_ace) do
      [
        Card.new('2', 'D'),
        Card.new('J', 'C'),
        Card.new('K', 'H'),
        Card.new('Q', 'S'),
        Card.new('10', 'C')
      ]
    end

    it 'returns true if the cards include ace' do
      poker = Poker.new(ace)
      expect(poker.ace?).to be_truthy
    end

    it 'returns false if the cards does not include ace' do
      poker = Poker.new(not_ace)
      expect(poker.ace?).to be_falsy
    end
  end

  describe '#evaluate' do
    let(:five_of_kind) do
      [
        Card.new('A', 'C'),
        Card.new('A', 'D'),
        Card.new('A', 'S'),
        Card.new('A', 'H'),
        Card.new('A', 'C')
      ]
    end
    let(:straight_flush) do
      [
        Card.new('A', 'C'),
        Card.new('2', 'C'),
        Card.new('3', 'C'),
        Card.new('4', 'C'),
        Card.new('5', 'C')
      ]
    end
    let(:four_of_kind) do
      [
        Card.new('A', 'C'),
        Card.new('A', 'D'),
        Card.new('A', 'S'),
        Card.new('A', 'H'),
        Card.new('1', 'C')
      ]
    end
    let(:full_house) do
      [
        Card.new('10', 'C'),
        Card.new('10', 'D'),
        Card.new('10', 'S'),
        Card.new('K', 'H'),
        Card.new('K', 'S')
      ]
    end

    let(:flush) do
      [
        Card.new('3', 'C'),
        Card.new('K', 'C'),
        Card.new('J', 'C'),
        Card.new('5', 'C'),
        Card.new('7', 'C')
      ]
    end

    let(:staright) do
      [
        Card.new('A', 'S'),
        Card.new('2', 'D'),
        Card.new('5', 'H'),
        Card.new('3', 'S'),
        Card.new('4', 'C')
      ]
    end
    let(:three_of_kind) do
      [
        Card.new('J', 'C'),
        Card.new('J', 'D'),
        Card.new('J', 'S'),
        Card.new('A', 'H'),
        Card.new('2', 'C')
      ]
    end
    let(:two_pairs) do
      [
        Card.new('Q', 'C'),
        Card.new('9', 'D'),
        Card.new('Q', 'C'),
        Card.new('K', 'H'),
        Card.new('K', 'S')
      ]
    end
    let(:one_pair) do
      [
        Card.new('K', 'C'),
        Card.new('K', 'D'),
        Card.new('Q', 'S'),
        Card.new('A', 'H'),
        Card.new('2', 'D')
      ]
    end

    it 'returns five of a kind when all cards have same face' do
      poker = Poker.new(five_of_kind)
      expect(poker.evaluate).to eq('Five of a kind')
    end

    it 'returns true if cards are straight? and flush?' do
      poker = Poker.new(straight_flush)
      expect(poker.evaluate).to eq('Straight flush')
    end

    it 'returns true if four cards have same face' do
      poker = Poker.new(four_of_kind)
      expect(poker.evaluate).to eq('Four_of_kind')
    end

    it 'returns true if three cards have same face and two cards have same face' do
      poker = Poker.new(full_house)
      expect(poker.evaluate).to eq('Full house')
    end

    it 'returns true if all cards have same suit' do
      poker = Poker.new(flush)
      expect(poker.evaluate).to eq('Flush')
    end

    it 'returns true if all cards have sequential face ' do
      poker = Poker.new(staright)
      expect(poker.evaluate).to eq('Straight')
    end

    it 'returns true if three cards have same face' do
      poker = Poker.new(three_of_kind)
      expect(poker.evaluate).to eq('Three of a Kind')
    end

    it 'returns true if there are two pairs' do
      poker = Poker.new(two_pairs)
      expect(poker.evaluate).to eq('Two pair')
    end

    it 'returns true if there is one pair' do
      poker = Poker.new(one_pair)
      expect(poker.evaluate).to eq('One pair')
    end
  end
end
