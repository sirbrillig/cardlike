require 'spec_helper'

describe "Building a deck" do
  context "with a bunch of cards defined in the block" do
    before do
      Cardlike.type_of_card :playing_card do
        has :value
        has :suit
      end

      Cardlike.deck "Poker Deck" do
        new_playing_card "Ace of Spades" do
          value 11
          suit 'Spades'
        end

        new_playing_card "Ace of Diamonds" do
          value 11
          suit 'Diamonds'
        end

        new_playing_card "Five of Clubs" do
          value 5
          suit 'Clubs'
        end
      end

    end

    it "contains the right number of cards" do
      Cardlike.the_deck("Poker Deck").size.should eq 3
    end

    it "contains a card created in the block" do
      Cardlike.the_deck("Poker Deck").first.name.should eq "Ace of Spades"
    end

  end

end
