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

      it "does affect other Card instances" do
        @card2 = Cardlike.card "Castle"
        @card2.should respond_to :value
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

    it "creates a new Class" do
      @playing_card.should be_a_kind_of Class
    end

    it "creates a subclass of Card" do
      @playing_card.should < Cardlike::Card
    end

    it "creates a dynamic custom Class" do
      @playing_card.name.should eq "PlayingCard"
    end

    it "creates an accessor for the custom field" do
      @playing_card.new.should respond_to :suit
    end
    
    context "when instantiated" do
      before do
        @card = @playing_card.create "Six of Spades" do
          value 6
          suit 'Spades'
        end
      end

      it "creates a custom Card object" do
        @card.should be_a_kind_of Cardlike::Card
      end

      it "creates an accessor for the custom field" do
        @card.should respond_to :suit
      end

      it "does not affect other Card instances" do
        @card2 = Cardlike.card "Castle"
        @card2.should_not respond_to :suit
      end

      it "sets the field properly" do
        @card[:suit].should eq 'Spades'
      end

      it "does not allow fields to be set again" do
        lambda { @card.suit 'Clubs' }.should raise_error(StandardError)
      end

    end

  end

end
