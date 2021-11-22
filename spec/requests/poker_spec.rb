# frozen_string_literal: true

describe 'Poker requests', type: :request do
  include RSpecHtmlMatchers

  describe '#play_poker' do
    it 'returns poker form' do
      get '/'
      expect(response).to have_http_status(:ok)
      expect(response.body).to have_form('/evaluate_cards', :post)
    end
  end
end
