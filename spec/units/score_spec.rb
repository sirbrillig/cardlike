require 'spec_helper'

describe Cardlike do
  describe ".score" do
    context "with a new target" do
      before do
        Cardlike.clear_scores
        Cardlike.score :foobar
      end

      it "sets a new target with the score" do
        Cardlike.the_score(:foobar).should eq 1
      end
    end

    context "with an existing target" do
      before do
        Cardlike.game do
          3.times { score :foobaz }
        end
      end

      it "increments the score for the target" do
        Cardlike.the_score(:foobaz).should eq 3
      end
    end
  end

  describe ".clear_scores" do
    before do
      Cardlike.score :barfoo
      Cardlike.clear_scores
    end

    it "removes all scores" do
      Cardlike.scores.should be_empty
    end
  end

  describe ".scores" do
    before do
      Cardlike.clear_scores
      Cardlike.game do
        2.times { score :foo }
        3.times { score :bar }
        1.times { score :baz }
      end
    end

    it "returns a hash of target => score" do
      hash = {:foo => 2, :bar => 3, :baz => 1}
      Cardlike.scores.should eq hash
    end
  end
end

