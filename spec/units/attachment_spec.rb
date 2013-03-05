require 'spec_helper'

describe Cardlike::Card do
  let(:card) { Cardlike.card "Normal Card" }
  let(:attachment1) { Cardlike.card "Better Card" }
  let(:attachment2) { Cardlike.card "Even Better Card" }

  context "when another card is attached" do
    before do
      card.attach attachment1
    end

    it "adds that card as an attachment" do
      card.attachments.should include Cardlike.the_card('Better Card')
    end

    context "when a second card is attached" do
      before do
        card.attach attachment2
      end

      it "adds that card as an attachment" do
        card.attachments.should include Cardlike.the_card('Even Better Card')
      end

      it "has both attachments" do
        card.attachments.size.should eq 2
      end
    end
  end
end
