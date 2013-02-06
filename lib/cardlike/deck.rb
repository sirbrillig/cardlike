class Cardlike::Deck < Array
  attr_accessor :name

  def initialize(options={})
    self.name = options[:name]
    options[:cards].each { |c| self << c } if options[:cards]
  end

  # Return an array of cards drawn from the deck.
  def draw(count=1)
    i = []
    count.times { i.push pop }
    i
  end
end


