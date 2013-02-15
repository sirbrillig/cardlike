require 'spec_helper'

describe "A hand of cards" do
  context "with 4 cards added" do
    before do
      Cardlike.hand "Player 1" do
        card "Boring Card One"
        card "Boring Card Two"
        card "Boring Card Three"
        card "Boring Card Four"
      end
    end

    it "has 4 cards" do
      Cardlike.the_hand("Player 1").size.should eq 4
    end

    it "contains the first card" do
      Cardlike.the_hand("Player 1").first.name.should eq "Boring Card One"
    end

    context "when removing a card by name" do
      before do
        @card1 = Cardlike.the_hand("Player 1").remove_card "Boring Card One"
      end

      it "can remove a specific card" do
        @card1.name.should eq "Boring Card One"
      end

      it "removes the card from the Hand" do
        Cardlike.the_hand("Player 1").size.should eq 3
      end
    end

    context "when removing a card at random" do
      before do
        @card1 = Cardlike.the_hand("Player 1").remove_random_card
      end

      it "removes a Card" do
        @card1.should be_a_kind_of Cardlike::Card
      end

      it "removes the card from the Hand" do
        Cardlike.the_hand("Player 1").size.should eq 3
      end
    end

    context "when removing a card at random with specific parameters (a block)" do
      before do
        @card1 = Cardlike.the_hand("Player 1").remove_random_card { |c| c.name =~ /^Boring Card T/ }
      end

      it "removes a card matching the parameters" do
        @card1.name.should satisfy { |s| ["Boring Card Two", "Boring Card Three"].include?(s) }
      end

      it "removes the card from the Hand" do
        Cardlike.the_hand("Player 1").size.should eq 3
      end
    end

    context "when removing a card by index" do
      before do
        @card1 = Cardlike.the_hand("Player 1").remove_card_at 3
      end

      it "can remove a specific card" do
        @card1.name.should eq "Boring Card Four"
      end

      it "removes the card from the Hand" do
        Cardlike.the_hand("Player 1").size.should eq 3
      end
    end

    context "when removing cards with remove_card_if" do
      before do
        @card1 = Cardlike.the_hand("Player 1").remove_card_if { |c| c.name =~ /Three/ }.first
      end

      it "removes and returns the correct card" do
        @card1.name.should eq "Boring Card Three"
      end

      it "removes the card from the Hand" do
        Cardlike.the_hand("Player 1").size.should eq 3
      end
    end
  end
end
