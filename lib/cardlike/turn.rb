module Cardlike
  def self.define_turn(&block)
    @turn = block
  end

  def self.the_turn
    @turn
  end

  def self.begin_new_turn(*args)
    @turn.call(*args)
  end
end
