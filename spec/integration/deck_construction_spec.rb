require 'spec_helper'

describe "Building a deck" do
  context "with a simple card" do
    before do
      Cardlike.game do
        deck "Simple Deck" do
          card "Boring Card"
        end
      end
    end

    it "has 1 card" do
      Cardlike.the_deck("Simple Deck").size.should eq 1
    end

    it "contains the first card" do
      Cardlike.the_deck("Simple Deck").first.name.should eq "Boring Card"
    end
  end

  context "with a bunch of cards defined in the block" do
    before do
      Cardlike.game do
        type_of_card :playing_card do
          has :value
          has :suit
        end

        deck "Poker Deck" do
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

    end

    it "contains the right number of cards" do
      Cardlike.the_deck("Poker Deck").size.should eq 3
    end

    it "contains a card created in the block" do
      Cardlike.the_deck("Poker Deck").first.name.should eq "Ace of Spades"
    end

    context "and another deck exists" do
      before do
        Cardlike.deck "Go Fish Deck" do
          new_playing_card "Seven of Spades" do
            value 7
            suit :spades
          end
        end
      end

      it "the first deck contains the right number of cards" do
        Cardlike.the_deck("Poker Deck").size.should eq 3
      end

      it "the new deck contains the right number of cards" do
        Cardlike.the_deck("Go Fish Deck").size.should eq 1
      end

    end
  end

  context "with a bunch of cards pre-defined" do
    before do
      Cardlike.type_of_card :playing_card do
        has :value
        has :suit
      end

      Cardlike.new_playing_card "King of Diamonds" do
        value 10
        suit :diamonds
      end

      Cardlike.new_playing_card "Three of Clubs" do
        value 3
        suit :clubs
      end

      Cardlike.deck "Blackjack Deck" do
        include_card "King of Diamonds"
        include_card "Three of Clubs"
      end
    end

    it "contains the right number of cards" do
      Cardlike.the_deck("Blackjack Deck").size.should eq 2
    end

    it "contains a card created in the block" do
      Cardlike.the_deck("Blackjack Deck").first.name.should eq "King of Diamonds"
    end

  end

  context "with multiple copies of a card" do
    before do
      Cardlike.type_of_card :playing_card do
        has :value
        has :suit
      end

      Cardlike.new_playing_card "Queen of Diamonds" do
        value 10
        suit :diamonds
      end

      Cardlike.deck "Copy Deck" do
        6.times { copy_card "Queen of Diamonds" }
      end
    end

    it "contains the right number of cards" do
      Cardlike.the_deck("Copy Deck").size.should eq 2
    end

    it "contains a card created in the block" do
      Cardlike.the_deck("Copy Deck").first.name.should eq "Queen of Diamonds"
    end

  end

end
