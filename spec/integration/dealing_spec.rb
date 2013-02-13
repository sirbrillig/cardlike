require 'spec_helper'

describe 'A deck of cards' do
  before do
    @cards = []
    @cards << Cardlike::Card.new(name: 'Leonardo')
    @cards << Cardlike::Card.new(name: 'Donatello')
    @cards << Cardlike::Card.new(name: 'Michaelangelo')
    @cards << Cardlike::Card.new(name: 'Raphael')

    @deck = Cardlike::Deck.new(name: 'Turtles', cards: @cards)
  end

  context 'when a card is drawn' do
    before do
      @drawn = @deck.draw
    end

    it 'is one of the cards from the deck' do
      @cards.should include @drawn
    end

    it 'is no longer in the deck' do
      @deck.should_not include @drawn
    end
  end

  context "when a card is drawn into a Hand" do
    before do
      @hand = Cardlike::Hand.new(name: 'Player 1')
      @drawn = @deck.draw_into @hand
    end

    it "inserts the card into the Hand" do
      @hand.should include @drawn
    end

    it "removes the card from the Deck" do
      @deck.should_not include @drawn
    end
  end
end
