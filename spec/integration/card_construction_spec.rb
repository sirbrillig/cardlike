require 'spec_helper'

describe 'Defining a card' do
  context "using the basic card DSL" do

    context "for a basic card" do
      before do
        @card = Cardlike.card "Fire Monster"
      end

      it "creates a Card object" do
        @card.should be_a_kind_of Cardlike::Card
      end

      it "properly sets the card name" do
        @card.name.should eq "Fire Monster"
      end
    end

  end

  context "using the custom card DSL" do
    before do
      @playing_card = Cardlike.type_of_card :playing_card do
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

    it "creates an accessor for the custom property" do
      @playing_card.new.should respond_to :suit
    end

    context "when instantiated with the 'new_' factory" do
      before do
        deck = Cardlike.deck "Test" do
          new_playing_card "Six of Spades" do
            value 6
            suit 'Spades'
          end
        end
        @card = deck.first
      end

      it "creates a custom Card object" do
        @card.should be_a_kind_of Cardlike::Card
      end

      it "creates an accessor for the custom property" do
        @card.should respond_to :suit
      end

      it "responds to the Card.card_type method with the type" do
        @card.card_type.should eq :playing_card
      end

      it "does not allow setting of card_type" do
        lambda { @card.card_type = 'Special Card' }.should raise_error(StandardError)
      end
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

      it "creates an accessor for the custom property" do
        @card.should respond_to :suit
      end

      it "does not affect other Card instances" do
        @card2 = Cardlike.card "Castle"
        @card2.should_not respond_to :suit
      end

      it "sets the property properly" do
        @card[:suit].should eq 'Spades'
      end

      it "also returns the property from the accessor version of the setter" do
        @card.suit.should eq 'Spades'
      end

      it "does not allow properties to be set again" do
        lambda { @card.suit 'Clubs' }.should raise_error(StandardError)
      end

    end

  end

  context "that includes a block" do
    before do
      Cardlike.game do
        type_of_card :monster_card do
          has_block :action
        end

        new_monster_card "Ogre" do
          action do
            :action_complete
          end
        end
      end
    end

    it "completes the action" do
      Cardlike.the_card("Ogre").action.call.should eq :action_complete
    end
  end

end
