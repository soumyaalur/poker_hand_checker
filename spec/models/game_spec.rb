# frozen_string_literal: true

require 'rails_helper'

describe Game do
  describe '#initialize_cards' do
    it 'initializes cards' do
      subject.initialize_cards
      expect(subject.cards).to be_present
      expect(subject.cards.length).to eq(52)
    end
  end
end
