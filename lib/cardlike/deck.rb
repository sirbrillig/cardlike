class Cardlike::Deck < Array
  attr_accessor :name

  def initialize(options={})
    self.name = options[:name]
    options[:cards].each { |c| self << c } if options[:cards]
  end

  def draw
    self.pop
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
end
