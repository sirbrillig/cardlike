require 'spec_helper'

describe 'A deck of cards' do
  context "for a simple deck" do
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

  context "for a deck of custom cards" do
    before do
      Cardlike.game do
        type_of_card :monster_card do
          has :strength
        end

        deck "Monsters" do
          new_monster_card("Giant Snake") { strength 5 }
          new_monster_card("Giant Spider") { strength 3 }
          new_monster_card("Giant Giant") { strength 8 }
          new_monster_card("Giant Cow") { strength 2 }
        end
      end
    end

    context "when a card is drawn into a Hand" do
      before do
        @top_card = Cardlike.game do
          hand "My Hand"
          top_card = the_deck("Monsters").last
          the_deck("Monsters").draw_into the_hand("My Hand")
          top_card
        end
      end

      it "removes a card from the deck" do
        Cardlike.the_deck("Monsters").size.should eq 3
      end

      it "adds a card to the Hand" do
        Cardlike.the_hand("My Hand").size.should eq 1
      end

      it "the drawn card is the top card from the deck" do
        @top_card.should eq Cardlike.the_hand("My Hand").first
      end
    end
  end
end
