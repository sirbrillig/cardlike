#
# Represents a game card. Best used with the Card and Deck DSL. See Cardlike.
#
class Cardlike::Card
  attr_accessor :name, :text

  #
  # Create an instance of a Card. Arguments are a hash that should include
  # +:name+ at a minimum.  Optionally all cards have a +text+ accessor that can
  # be set in the constructor by including the option +:text+. Perhaps a better
  # idea is to use Card.create or Cardlike.card.
  #
  def initialize(options={})
    self.name = options[:name]
    self.text = options[:text]
    @properties = {}
  end

  # 
  # Factory method to create an instance of a Card. This sets the name of the
  # card and its properties using the Card DSL in the corresponding block. You
  # can also use Cardlike.card, which does the same thing. Probably more useful
  # is to create custom card types using Cardlike.type_of_card and create them
  # using the +new_+ methods.
  #
  #   Card.create "Big Monster" do
  #     text "Spend 1 Mana to Attack"
  #   end
  #
  # Preferred over Card.new.
  #
  def self.create(name, &block)
    c = self.new(name: name)
    c.instance_eval(&block) if block_given?
    c
  end

  # 
  # DSL method for setting the card text. Still works as a getter if no args are
  # passed.
  #
  def text(card_text=nil)
    return @text unless card_text
    @text = card_text
  end

  # 
  # Return custom properties of this Card. Custom properties can be set using
  # the Card.has method, ideally inside a Cardlike.type_of_card block.
  #
  #   @king_of_diamonds[:suit] # => 'Diamonds'
  #
  def [](prop)
    @properties[prop]
  end

  #
  # Class DSL method for setting custom properties for a Card. See
  # Cardlike.type_of_card.
  #
  def self.has(prop)
    define_method(prop, lambda { |arg| raise "Cards are immutable." if @properties.has_key? prop; @properties[prop] = arg })
  end

  def to_s
    t = []
    t << "Name: #{name}"
    t << "Text: #{text}" if text
    @properties.each { |p,v| t << "#{p}: #{v}" } 
    t.join("\n")
  end

end
