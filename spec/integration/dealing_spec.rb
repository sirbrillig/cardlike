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
      @hand = Hand.new(name: 'Player 1')
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
