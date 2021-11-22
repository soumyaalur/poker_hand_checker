# frozen_string_literal: true

class Card
  SUITES = %w[C D S H].freeze
  FACES = { 'A' => 1, '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, '7' => 7,
            '8' => 8, '9' => 9, '10' => 10, 'J' => 11, 'Q' => 12, 'K' => 13 }.freeze

  attr_accessor :face, :suite

  def initialize(face, suite)
    @face = face
    @suite = suite
  end
end
