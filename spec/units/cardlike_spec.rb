require 'spec_helper'

describe Cardlike do
  describe '.version' do
    it 'returns correct version' do
      Cardlike.version.should eq "Cardlike version #{Cardlike::VERSION}"
    end
  end
end
