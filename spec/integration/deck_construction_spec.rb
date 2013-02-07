require 'spec_helper'

describe 'Defining a card' do
  context "using the card DSL" do

    context "for a basic card" do
      before do
        #FIXME: I don't want to have to use the full path here.
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

    context "with a custom field specified inline" do
      before do
        include Cardlike::Card
        @card = card "Four of Spades" do
#           my :value is 4
        end
      end

      it "creates a Card object with the field as a hash key" do
        @card[:value].should eq 4
      end
    end

  end
end
