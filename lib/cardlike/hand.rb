#
# Represents a game hand. Best used with the Card and Deck DSL. See Cardlike.
#
class Cardlike::Hand < Cardlike::Deck
  def remove_card(card_name)
    self.delete(self.select { |card| card.name == card_name }.first)
  end

  #
  # Remove cards for which the block evaluates to true, returning removed cards
  # in an Array.
  #
  def remove_card_if(&block)
    matches = self.select { |card| yield(card) }
    matches.collect { |match| self.delete(match) }
  end
  
  def to_s
    puts "Hand: #{name}"
    self.each do |card|
      puts "-> #{card}\n"
    end
  end
end
