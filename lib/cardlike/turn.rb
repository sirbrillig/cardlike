module Cardlike
  # 
  # Define a turn block that can be run with Cardlike.begin_new_turn.
  #
  #   Cardlike.define_turn do |current_player|
  #     puts "#{current_player}'s turn"
  #   end
  #
  def self.define_turn(&block)
    @turn = block
  end

  #
  # Return the turn block set by Cardlike.define_turn.
  #
  def self.the_turn
    @turn
  end

  #
  # Call the block defined by Cardlike.define_turn. You can pass arguments to
  # the block as well.
  #
  def self.begin_new_turn(*args)
    @turn.call(*args)
  end
end
