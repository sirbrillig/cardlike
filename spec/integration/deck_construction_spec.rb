require 'spec_helper'

describe 'Defining a card' do
  context "using the basic card DSL" do

    context "for a basic card" do
      before do
        @card = Cardlike.card "Fire Monster" do
          text "A red-hot monster."
        end
      end

      it "creates a Card object" do
        @card.should be_a_kind_of Cardlike::Card
      end

      it "properly sets the card name" do
        @card.name.should eq "Fire Monster"
      end

      it "properly sets the card text" do
        @card.text.should eq "A red-hot monster."
      end
    end

    context "with a custom field" do
      before do
        @card = Cardlike.card "Jack of Spades" do
          has :value
          value 10
        end
      end

      it "creates a Card object with the field as a hash key" do
        @card[:value].should eq 10
      end

      it "does not affect other Card instances" do
        @card2 = Cardlike.card "Castle"
        @card2.should_not respond_to :value
      end
    end

  end

  context "using the custom card DSL" do
    before do
      @playing_card = Cardlike.type_of_card "Playing Card" do
        has :value
        has :suit
      end
    end

    it "creates a custom Card object" do
      @playing_card.should be_a_kind_of Card
    end

    it "creates a new Class" do
      @playing_card.class.should eq "PlayingCard"
    end

    context "when setting custom fields on an instance of that card" do
      it "sets the field"
    end
  end
end
