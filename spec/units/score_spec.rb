require 'spec_helper'

describe Cardlike do
  describe ".score" do
    context "with a new target" do
      it "sets a new target with the score"
    end

    context "with an existing target" do
      it "increments the score for the target"
    end
  end

  describe ".scores" do
    it "returns a hash of target => [scores]"
  end
end

