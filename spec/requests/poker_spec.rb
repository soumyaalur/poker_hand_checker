# frozen_string_literal: true

describe 'Poker requests', type: :request do
  include RSpecHtmlMatchers

  describe '#play_poker' do
    it 'returns poker form' do
      get '/'
      expect(response).to have_http_status(:ok)
      expect(response.body).to have_form('/evaluate_cards', :post) do
        with_select('cards[card1]')
        with_select('cards[card2]')
        with_select('cards[card3]')
        with_select('cards[card4]')
        with_select('cards[card5]')
        with_submit('SUBMIT CARDS')
      end
    end
  end

  describe '#evaluate_cards' do
    let(:valid_request_body) do
      {
        cards: {
          card1: 'AC',
          card2: '2C',
          card3: '3C',
          card4: '4C',
          card5: '5C'
        }
      }
    end
    let(:invalid_request_body) do
      {
        cards: {
          card1: 'AC',
          card2: 'AC',
          card3: '3C',
          card4: '4C',
          card5: '5C'
        }
      }
    end

    it 'evaluates a poker hand' do
      post '/evaluate_cards', params: valid_request_body

      expect(response).to have_http_status(:ok)
      expect(response.body).to match /Result:/
      expect(response.body).to_not match /Errors:/
      expect(response.body).to match /Straight flush/
      expect(response.body).to have_form('/evaluate_cards', :post) do
        with_select('cards[card1]')
        with_select('cards[card2]')
        with_select('cards[card3]')
        with_select('cards[card4]')
        with_select('cards[card5]')
        with_submit('SUBMIT CARDS')
      end
    end

    it 'displays error if a user selects invalid cards' do
      post '/evaluate_cards', params: invalid_request_body

      expect(response).to have_http_status(:ok)
      expect(response.body).to_not match /Result:/
      expect(response.body).to match /Errors:/
      expect(response.body).to match /Duplicate card ac/
      expect(response.body).to have_form('/evaluate_cards', :post) do
        with_select('cards[card1]')
        with_select('cards[card2]')
        with_select('cards[card3]')
        with_select('cards[card4]')
        with_select('cards[card5]')
        with_submit('SUBMIT CARDS')
      end
    end
  end
end
