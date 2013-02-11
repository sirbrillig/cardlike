require 'spec_helper'

describe Cardlike::Deck do
  let (:deck) { Cardlike::Deck.new(cards: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k']) }

  describe "#shuffle" do
    before do
      @orig_deck = deck.dup
      @shuffled = deck.shuffle
    end

    it "returns a Deck" do
      @shuffled.should be_a_kind_of Cardlike::Deck
    end

    it "returns a differently-ordered deck" do
      @shuffled.should_not eq @orig_deck
    end

    it "retains the order of the deck" do
      deck.should eq @orig_deck
    end
  end

  describe "#shuffle!" do
    before do
      @orig_deck = deck.dup
      @shuffled = deck.shuffle!
    end

    it "the deck remains a Deck" do
      @shuffled.should be_a_kind_of Cardlike::Deck
    end

    it "returns a differently-ordered deck" do
      deck.should_not eq @orig_deck
    end

    it "changes the order of the deck" do
      deck.should_not eq @orig_deck
    end
  end
end
