require 'spec_helper'

describe Cardlike::Deck do
  let (:deck) { Cardlike::Deck.new(cards: ['a', 'b', 'c']) }

  describe "#shuffle" do
    before do
      @orig_deck = deck.dup
    end

    it "returns a differently-ordered deck" do
      deck.shuffle.should_not eq @orig_deck
    end

    it "retains the order of the deck" do
      deck.shuffle
      deck.should eq @orig_deck
    end
  end

  describe "#shuffle!" do
    before do
      @orig_deck = deck.dup
    end

    it "returns a differently-ordered deck" do
      deck.shuffle!.should_not eq @orig_deck
    end

    it "changes the order of the deck" do
      deck.shuffle!
      deck.should_not eq @orig_deck
    end
  end
end
