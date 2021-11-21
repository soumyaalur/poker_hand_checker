# frozen_string_literal: true

Rails.application.routes.draw do
  root 'poker#play_poker'
  post 'evaluate_cards', to: 'poker#evaluate_cards'
end
