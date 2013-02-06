require 'spec_helper'

describe 'A deck of cards' do
  before do
    @cards = []
    @cards << Cardlike::Card.new(name: 'Leonardo', text: 'Has two swords.')
    @cards << Cardlike::Card.new(name: 'Donatello', text: 'Has a Bo staff.')
    @cards << Cardlike::Card.new(name: 'Michaelangelo', text: 'Has Nunchuku.')
    @cards << Cardlike::Card.new(name: 'Raphael', text: 'Has Sai.')

    @deck = Cardlike::Deck.new(name: 'Turtles', cards: @cards)
  end

  context 'when a card is drawn' do
    before do
      @drawn = @deck.draw.first
    end

    it 'is one of the cards from the deck' do
      @cards.should include @drawn
    end

    it 'is no longer in the deck' do
      @deck.should_not include @drawn
    end
  end
end
