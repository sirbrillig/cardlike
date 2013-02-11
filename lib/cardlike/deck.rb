#
# Represents a game deck. Best used with the Card and Deck DSL. See Cardlike.
#
class Cardlike::Deck < Array
  attr_accessor :name

  def initialize(options={})
    self.name = options[:name]
    options[:cards].each { |c| self << c } if options[:cards]
  end

  def draw
    self.pop
  end

  def shuffle
    self.dup.shuffle!
  end

  def +(ary)
    ary.each { |a| self << a }
    self
  end

  def include_card(name)
    raise "Card '#{name}' not found." unless card = Cardlike.the_card(name)
    self << card
  end

  def copy_card(name)
    raise "Card '#{name}' not found." unless card = Cardlike.the_card(name)
    copy = card.dup
    self << copy
  end

  def card(name, &block)
    c = Cardlike.card(name, &block)
    self << c
    c
  end

  def draw_into(deck)
    card = draw
    deck << card
    card
  end
end
