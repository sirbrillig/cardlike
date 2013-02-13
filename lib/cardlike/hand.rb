#
# Represents a game hand. Best used with the Card and Deck DSL. See Cardlike and
# Cardlike::Deck, from which this inherits.
#
class Cardlike::Hand < Cardlike::Deck
  #
  # Remove and return a Card from this hand by name.
  #
  def remove_card(card_name)
    self.delete(self.select { |card| card.name == card_name }.first)
  end

  #
  # Remove cards for which the block evaluates to true, returning removed cards
  # in an Array. If no cards are found, returns an empty array.
  #
  def remove_card_if(&block)
    matches = self.select { |card| yield(card) }
    matches.collect { |match| self.delete(match) }
  end
  
  def to_s
    cards = ["Hand: #{name}"]
    cards += self.collect { |c| "-> #{c}" }
    cards.join("\n")
  end
end
