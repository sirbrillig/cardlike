class Cardlike::Hand < Cardlike::Deck
  # FIXME: add ability to pull out individual cards.
  
  def to_s
    puts "Hand: #{name}"
    self.each do |card|
      puts "-> #{card}\n"
    end
  end
end
