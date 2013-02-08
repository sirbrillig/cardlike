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
  end
end
