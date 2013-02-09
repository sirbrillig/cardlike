#
# Represents a game hand. Best used with the Card and Deck DSL. See Cardlike.
#
class Cardlike::Hand < Cardlike::Deck
  def remove_card(card_name)
    self.delete(self.select { |card| card.name == card_name }.first)
  end
  
  def to_s
    puts "Hand: #{name}"
    self.each do |card|
      puts "-> #{card}\n"
    end
  end
end
