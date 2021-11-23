# frozen_string_literal: true

require 'rails_helper'

describe Player do
  describe '#play' do
    let(:player_cards) { %w[AC 2C 3C 4C 5C] }

    it "doesn't throw error when the cards are valid" do
      player = Player.new(%w[AC 2C 3C 4C 5C])

      expect { player.play }.to_not raise_error
    end

    it 'throws error when the cards are invalid' do
      player = Player.new(%w[AC 20C 3C 4C 5C])

      expect { player.play }.to raise_error('Invalid card 20C')
    end

    it 'calls poker evaluate when the cards are valid' do
      player = Player.new(%w[AC 2C 3C 4C 5C])

      expect_any_instance_of(Poker).to receive(:evaluate)
      player.play
    end
  end

  describe '#validate_cards' do
    it 'returns duplicate error message when the cards are repeated' do
      player = Player.new(%w[2C 2C 3D 9S 10D])

      errors = player.send(:validate_cards)
      expect(errors).to be_present
      expect(errors.length).to eq(1)
      expect(errors[0]).to eq('Duplicate card 2C')
    end

    it 'returns invalid card error message when there is an unkown card' do
      player = Player.new(%w[2C 2G 3D 9S 10D])

      errors = player.send(:validate_cards)
      expect(errors).to be_present
      expect(errors.length).to eq(1)
      expect(errors[0]).to eq('Invalid card 2G')
    end

    it 'returns errors if there are more than five cards' do
      player = Player.new(%w[2C 2S 3D 9S 10D JD])

      errors = player.send(:validate_cards)
      expect(errors).to be_present
      expect(errors.length).to eq(1)
      expect(errors[0]).to eq('More than five cards')
    end

    it 'returns multiple errors if there are multiple errors' do
      player = Player.new(%w[2C 2G 2C 9S 10D])

      errors = player.send(:validate_cards)
      expect(errors).to be_present
      expect(errors.length).to eq(2)
      expect(errors[0]).to eq('Invalid card 2G')
      expect(errors[1]).to eq('Duplicate card 2C')
    end
  end
end
