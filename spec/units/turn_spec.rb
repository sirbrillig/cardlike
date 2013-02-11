require 'spec_helper'

describe Cardlike do
  describe ".define_turn" do
    before do
      Cardlike.define_turn { :foobar }
    end

    it "defines a turn accessible by .the_turn" do
      Cardlike.the_turn.should_not be_nil
    end
  end

  describe ".begin_new_turn" do
    before do
      Cardlike.define_turn { :foobar }
      @result = Cardlike.begin_new_turn
    end

    it "returns the result of the turn block" do
      @result.should eq :foobar
    end
  end
end
